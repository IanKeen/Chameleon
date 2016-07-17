//
//  DNDStatus.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

public struct DNDStatus {
    let dnd_enabled: Bool
    let next_dnd_start_ts: Int
    let next_dnd_end_ts: Int
    let snooze_enabled: Bool
    let snooze_endtime: Int?
}
