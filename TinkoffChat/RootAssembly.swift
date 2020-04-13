//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
