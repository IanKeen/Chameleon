//
//  DNDStatus.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

public struct DNDStatus {
    public let dnd_enabled: Bool
    public let next_dnd_start_ts: Int
    public let next_dnd_end_ts: Int
    public let snooze_enabled: Bool
    public let snooze_endtime: Int?
}
