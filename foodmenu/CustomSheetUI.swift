import SwiftUI

@available(iOS 15.0, *)
struct CustomSheet_UI<Content: View>: UIViewControllerRepresentable {
    
    let content: Content
    @Binding var isPresented: Bool
    let detents : [UISheetPresentationController.Detent]
    let smallestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    
    init(isPresented: Binding<Bool>, detents : [UISheetPresentationController.Detent] = [.medium(), .large()], smallestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium, prefersScrollingExpandsWhenScrolledToEdge: Bool = false, prefersEdgeAttachedInCompactHeight: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.detents = detents
        self.smallestUndimmedDetentIdentifier = smallestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self._isPresented = isPresented
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> CustomSheetViewController<Content> {
        let vc = CustomSheetViewController(coordinator: context.coordinator, detents : detents, smallestUndimmedDetentIdentifier: smallestUndimmedDetentIdentifier, prefersScrollingExpandsWhenScrolledToEdge:  prefersScrollingExpandsWhenScrolledToEdge, prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight, content: {content})
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CustomSheetViewController<Content>, context: Context) {
        if isPresented{
            uiViewController.presentModalView()
        }else{
            uiViewController.dismissModalView()
        }
    }
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: CustomSheet_UI
        init(_ parent: CustomSheet_UI) {
            self.parent = parent
        }
        //Adjust the variable when the user dismisses with a swipe
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isPresented{
                parent.isPresented = false
            }
            
        }
        
    }
}

@available(iOS 15.0, *)
class CustomSheetViewController<Content: View>: UIViewController {
    let content: Content
    let coordinator: CustomSheet_UI<Content>.Coordinator
    let detents : [UISheetPresentationController.Detent]
    let smallestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    
    init(coordinator: CustomSheet_UI<Content>.Coordinator, detents : [UISheetPresentationController.Detent] = [.medium(), .large()], smallestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium, prefersScrollingExpandsWhenScrolledToEdge: Bool = false, prefersEdgeAttachedInCompactHeight: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.coordinator = coordinator
        self.detents = detents
        self.smallestUndimmedDetentIdentifier = smallestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func dismissModalView(){
        dismiss(animated: true, completion: nil)
    }
    func presentModalView(){

        let hostingController = UIHostingController(rootView: content)
        
        hostingController.modalPresentationStyle = .popover
        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
        if let hostPopover = hostingController.popoverPresentationController {
            hostPopover.sourceView = super.view
            let sheet = hostPopover.adaptiveSheetPresentationController
            sheet.detents = detents
            sheet.largestUndimmedDetentIdentifier = smallestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            sheet.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            
        }
        if presentedViewController == nil{
            present(hostingController, animated: true, completion: nil)
        }
    }
}
