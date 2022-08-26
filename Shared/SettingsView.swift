//
//  SettingsView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameSetting: GameSetting
    @State var isEditingUsername1: Bool = false
    @State var isEditingUsername2: Bool = false
    
    var body: some View {
        VStack{
            EditableTextView(label: "White Name", editableText: $gameSetting.player1Name, isEditingUsername: $isEditingUsername1)
            EditableTextView(label: "Black Name", editableText: $gameSetting.player2Name, isEditingUsername: $isEditingUsername2)
            Toggle("Pass To Play", isOn: $gameSetting.passToPlay)
            HStack{
                Text("Bot Difficulty:")
                Picker("", selection: $gameSetting.botDifficulty) {
                    ForEach(BotDifficulty.allCases, id: \.self) { value in
                        Text(toBotDiffString(value))
                            .tag(value)
                    }
                }
                .customButton(0.2)
                .rightAligned()
            }
            Spacer()
        }
        .padding()
        .font(.title)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GameSetting())
    }
}

struct EditableTextView: View{
    var label: String = ""
    @Binding var editableText : String
    @State var tempString : String = ""
    @Binding var isEditingUsername : Bool
    var body: some View{
        HStack{
            if (!isEditingUsername){
                HStack{
                    Text(label + ": " + editableText)
                    
                    Spacer()
                    
                    Button(action:{
                        isEditingUsername.toggle()
                        tempString = editableText
                    }){
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                }
            } else {
                HStack{
                    TextField("change " + label, text: $tempString)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.green, lineWidth: 2)
                                .opacity(0.7)
                        )
                    
                    Spacer()
                    
                    //cancel
                    Button(action:{
                        isEditingUsername.toggle()
                    }){
                        Image(systemName: "x.circle")
                            .foregroundColor(.blue)
                    }
                    
                    //confirm
                    Button(action:{
                        editableText = tempString
                        isEditingUsername.toggle()
                    }){
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
        }
    }
}
