//
//  ToastModifier.swift
//  Suwatte (iOS)
//
//  Created by Mantton on 2022-08-08.
//

import Foundation
import SwiftUI

struct ToastModifier: ViewModifier {
    @ObservedObject var toastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $toastManager.show) {
                toastManager.toast
            }
    }
}

extension View {
    func toaster() -> some View {
        modifier(ToastModifier())
    }
    func toast2() -> some View {
        modifier(ToastModifier2())
    }
}


struct ToastModifier2: ViewModifier {
    @EnvironmentObject var toaster: ToastManager2
    let bottomPadding = (KEY_WINDOW?.safeAreaInsets.bottom ?? 0) + 20
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!toaster.loading)
            .blur(radius: toaster.loading ? 3 : 0)
            .overlay {
                if toaster.loading {
                    ZStack {
                        BlurView(style: .prominent)
                        ProgressView()
                    }
                    .frame(width: 44, height: 44)
                    .cornerRadius(14)
                    .transition(.opacity)
                }
                
            }
            .overlay(alignment: .bottom) {
                if let toast = toaster.toast {
                    ToastView(toast: toast.type)
                        .onTapGesture {
                            toaster.cancel()
                        }
                        .padding(.bottom, bottomPadding)
                        .padding(.horizontal)
                        .id(toast.id)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut(duration: 0.35), value: toaster.toast)
            .animation(.easeIn(duration: 0.25), value: toaster.loading)
    }
}


struct ToastView: View {
    var toast: ToastManager2.ToastType
    var body: some View {
        Group {
            switch toast {
                case let .info(msg):
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                        Text(msg)
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                    .padding(.all, 12)
                    .background(BlurView())
                    .cornerRadius(7)
                case let .error(error, msg):
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.red)
                        Group {
                            if let error {
                                Text("Error: \(error.localizedDescription)")
                            } else {
                                Text(msg)
                            }
                        }
                        .font(.footnote.weight(.light))
                    }
                    .padding(.all, 12)
                    .background(BlurView())
                    .cornerRadius(7)
                    
            }
        }
        .shadow(radius: 0.5)
    }
}
struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    var style: UIBlurEffect.Style = .systemMaterial
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
