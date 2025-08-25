//
//  ChargeHistory.swift
//  TeslaSwiftDemoTests
//
//  Created by João Nunes on 29/10/2023.
//  Copyright © 2023 Joao Nunes. All rights reserved.
//

import Foundation

public struct ChargeHistory: Codable {
    let screenTitle: String
    let screenSubtitle: String
    let totalCharged: Charged
    let totalChargedBreakdown: Breakdown
    let chargingHistoryGraph: Graph
    let setRatePlan: RatePlan
    let totalChargedEnergyBreakdown: Breakdown
    let chargingTips: Tips
    let timePeriodLimit: TimePeriodLimit

    enum CodingKeys: String, CodingKey {
        case screenTitle = "screen_title"
        case screenSubtitle = "screen_subtitle"
        case totalCharged = "total_charged"
        case totalChargedBreakdown = "total_charged_breakdown"
        case chargingHistoryGraph = "charging_history_graph"
        case setRatePlan = "set_rate_plan"
        case totalChargedEnergyBreakdown = "total_charged_energy_breakdown"
        case chargingTips = "charging_tips"
        case timePeriodLimit = "time_period_limit"
    }

    public struct Charged: Codable {
        let value: String
        let rawValue: Int
        let afterAdornment: String
        let title: String

        enum CodingKeys: String, CodingKey {
            case value
            case rawValue = "raw_value"
            case afterAdornment = "after_adornment"
            case title
        }
    }

    public struct Breakdown: Codable {
        let home, superCharger, other, work: BreakdownItem

        enum CodingKeys: String, CodingKey {
            case home
            case superCharger = "super_charger"
            case other
            case work
        }
    }

    public struct BreakdownItem: Codable {
        let value: String
        let rawValue: Int?
        let afterAdornment: String
        let subTitle: String?

        enum CodingKeys: String, CodingKey {
            case value
            case rawValue = "raw_value"
            case afterAdornment = "after_adornment"
            case subTitle = "sub_title"
        }
    }

    struct Graph: Codable {
        let dataPoints: [DataPoint]
        let period: Period
        let interval: Int
        let xLabels: [XLabel]
        let yLabels: [YLabel]
        let horizontalGridLines: [Double]
        let verticalGridLines: [Double]
        let discreteX: Bool
        let yRangeMax: Double
        let XDomainMin: String?
        let XDomainMax: String?

        enum CodingKeys: String, CodingKey {
            case dataPoints = "data_points"
            case period
            case interval
            case xLabels = "x_labels"
            case yLabels = "y_labels"
            case horizontalGridLines = "horizontal_grid_lines"
            case verticalGridLines = "vertical_grid_lines"
            case discreteX = "discrete_x"
            case yRangeMax = "y_range_max"
            case XDomainMin = "XDomainMin"
            case XDomainMax = "XDomainMax"
        }
    }

    struct Period: Codable {
        let startTimestamp: Timestamp
        let endTimestamp: Timestamp

        enum CodingKeys: String, CodingKey {
            case startTimestamp = "start_timestamp"
            case endTimestamp = "end_timestamp"
        }
    }

    struct XLabel: Codable {
        let value: String
        let rawValue: Int

        enum CodingKeys: String, CodingKey {
            case value
            case rawValue = "raw_value"
        }
    }

    struct YLabel: Codable {
        let value: String
        let rawValue: Double?
        let afterAdornment: String?

        enum CodingKeys: String, CodingKey {
            case value
            case rawValue = "raw_value"
            case afterAdornment = "after_adornment"
        }
    }

    public struct DataPoint: Codable {
        let timestamp: TimestampContainer
        let values: [Value]
    }

    public struct TimestampContainer: Codable {
        let timestamp: Timestamp
        let displayString: String

        enum CodingKeys: String, CodingKey {
            case timestamp
            case displayString = "display_string"
        }
    }

    public struct Timestamp: Codable {
        let seconds: Int
    }

    public struct Value: Codable {
        let value: String
        let rawValue: Double?
        let afterAdornment: String
        let title: String?
        let subTitle: String?

        enum CodingKeys: String, CodingKey {
            case value
            case rawValue = "raw_value"
            case afterAdornment = "after_adornment"
            case title
            case subTitle = "sub_title"
        }
    }

    struct RatePlan: Codable {
        let messageCard: MessageCard
        let primaryLink: PrimaryLink

        enum CodingKeys: String, CodingKey {
            case messageCard = "message_card"
            case primaryLink = "primary_link"
        }
    }

    struct Card: Codable {
        let id: String
        let title: String
    }

    struct PrimaryLink: Codable {
        let type: Int
        let destination: String
        let label: String
    }

    struct Tips: Codable {
        let title: String
        let imageUrl: String
        let textSections: [TextSection]
        let tips: [TipLink]

        enum CodingKeys: String, CodingKey {
            case title
            case imageUrl = "image_url"
            case textSections = "text_sections"
            case tips
        }
    }

    struct TextSection: Codable {
        let paragraphs: [String]
    }

    struct TipLink: Codable {
        let link: LinkIcon
        let section: Section
    }

    struct LinkIcon: Codable {
        let link: Link
        let leftIcon: String
        let rightIcon: String

        enum CodingKeys: String, CodingKey {
            case link
            case leftIcon = "left_icon"
            case rightIcon = "right_icon"
        }
    }

    struct Link: Codable {
        let type: Int
        let destination: String
        let label: String
    }

    struct Section: Codable {
        let title: String
        let tips: [Tip]
    }

    struct Tip: Codable {
        let title: String
        let description: String
        let media: Media
    }

    struct Media: Codable {
        let type: Int
        let source: String
        let resizeMode: Int

        enum CodingKeys: String, CodingKey {
            case type
            case source
            case resizeMode = "resize_mode"
        }
    }

    public struct SetRatePlan: Codable {
        let messageCard: MessageCard
        let primaryLink: PrimaryLink
    }

    public struct MessageCard: Codable {
        let card: Card
        let imageID: String

        enum CodingKeys: String, CodingKey {
            case card
            case imageID = "image_id"
        }
    }

    public struct TimePeriodLimit: Codable {
        let ownershipStart: TimestampContainer
        let featureStart: TimestampContainer

        enum CodingKeys: String, CodingKey {
            case ownershipStart = "ownership_start"
            case featureStart = "feature_start"
        }
    }
}
