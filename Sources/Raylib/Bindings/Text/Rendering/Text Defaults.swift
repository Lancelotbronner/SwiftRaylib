//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-10.
//

import CRaylib

//MARK: - Text Defaults

extension Renderer {
	
	//MARK: Computed Properties
	
	public static var textSize: Int {
		get { currentTextSize }
		set { currentTextSize = newValue }
	}
	
	public static var textColor: Color {
		get { currentTextColor }
		set { currentTextColor = newValue }
	}
	
}

//MARK: Stores

private var currentTextSize: Int = 20
private var currentTextColor = Color.black
