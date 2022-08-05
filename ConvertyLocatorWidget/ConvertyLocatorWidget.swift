//
//  ConvertyLocatorWidget.swift
//  ConvertyLocatorWidget
//
//  Created by Jonas Gamburg on 05/08/2022.
//

import WidgetKit
import SwiftUI
import Intents
import MapKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ConvertyLocatorWidgetEntryView : View {
    var entry: Provider.Entry
    

    var body: some View {
        VStack {
            Text("Nearby exchange stores")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("1. Petra's Change")
                Text("2. Julius' Curiosities")
                Text("3. Poeta's Vision")
            }
        }
    }
}

@main
struct ConvertyLocatorWidget: Widget {
    let kind: String = "ConvertyLocatorWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ConvertyLocatorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ConvertyLocatorWidget_Previews: PreviewProvider {
    static var previews: some View {
        ConvertyLocatorWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
