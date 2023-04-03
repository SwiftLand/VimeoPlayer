//
//  PlayerSliderView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import SwiftUI

struct PlayerSliderViewEvent{
    var onDragStart:(()->())? = nil
    var onDragEnd:(()->())? = nil
}

struct PlayerSliderView: View {
    @Binding var value: Double
    @State var lastCoordinateValue: CGFloat = 0.0
    @State var isDraging:Bool = false
    
    var event:PlayerSliderViewEvent? = nil
    var sliderRange: ClosedRange<Double> = 0...1
    var thumbColor: Color = .white
    var minTrackColor: Color = .white
    var maxTrackColor: Color = Color(UIColor.lightGray)
  
    var body: some View {
        GeometryReader { gr in
            let thumbHeight = gr.size.height * 1.1
            let thumbWidth:CGFloat = 10//gr.size.width * 0.03
            let radius = gr.size.height * 0.15
            let minValue:CGFloat = 0//gr.size.width * 0.015
            let maxValue = gr.size.width //(gr.size.width * 0.98) - thumbWidth
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal:CGFloat = (self.value - lower) * scaleFactor + minValue
            
            ZStack {
                //max track
                ZStack{
                    Rectangle()
                        .foregroundColor(maxTrackColor)
                        .frame(width: gr.size.width, height: gr.size.height * 0.95)
                        .clipShape(RoundedRectangle(cornerRadius: radius))
                    //min Track
                    HStack {
                        Rectangle()
                            .foregroundColor(minTrackColor)
                            .frame(width: sliderVal, height: gr.size.height * 0.95)
                        Spacer()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    
                }.overlay{
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color(UIColor.lightGray), lineWidth: 1)
                }
                
                //thumb
                HStack {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(thumbColor)
                        .overlay{
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color(UIColor.lightGray), lineWidth: 0.7)
                        }
                        .frame(width: thumbWidth, height: thumbHeight)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if v.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    if !isDraging {
                                        isDraging = true
                                        event?.onDragStart?()
                                    }
                                }.onEnded{
                                    _ in
                                    self.isDraging = false
                                    event?.onDragEnd?()
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}

struct PlayerSliderView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSliderView(value:.constant(0)).frame(width: 300,height: 20)
    }
}
