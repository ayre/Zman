//
//  ZMJewishAlmanac.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–21.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

public enum ZMJewishAlmanac {
    //Null hypothesis
    case NotYomTov
    //Error
    case Undefined
    //Nisan
    case ErevPesach, Pesach, CholHaMoedPesach, YomHaShoa, Mimouna
    //Iyyar
    case PesachSheni, YomHaZikaron, YomHaAtzmaut, YomYerushalayim
    //Sivan
    case ErevShavuot, Shavuot
    //Tamuz
    case TzomTamuz
    //Av
    case TishaBeAv, TuBeAv
    //Elul
    //Tishrei
    case ErevRoshHashana, RoshHashana, TzomGedalia, ErevYomKippur, YomKippur, ErevSukkot, Sukkot, CholHaMoedSukkot, HoshanaRaba, SheminiAtzeret, SimchatTorah, Seharane
    //Cheshvan
    case Sigd
    //Kislev
    case ErevHanuka, Hanuka
    //Tevet
    case AsaraBeTevet
    //Shvat
    case TuBishvat
    //Adar
    case PurimKatan, Purim, TaanitEster, ShushanPurim, ShushanPurimKatan
    //Others
    case IsruHag
}