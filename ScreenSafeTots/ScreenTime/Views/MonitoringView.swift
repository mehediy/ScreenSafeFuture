//
//  MonitoringView.swift


import DeviceActivity
import SwiftUI

// MARK: - Device Activity Report
struct MonitoringView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    
    @State private var context: DeviceActivityReport.Context = .totalActivity
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .day,
                for: .now
            ) ?? DateInterval()
        )
    )
    
    var body: some View {
        DeviceActivityReport(context, filter: filter)
            .onAppear {
                filter = DeviceActivityFilter(
                    segment: .daily(
                        during: Calendar.current.dateInterval(
                            of: .day, for: .now
                        ) ?? DateInterval()
                    ),
                    users: .all,
                    devices: .init([.iPhone]),
                    applications: scheduleViewModel.selection.applicationTokens,
                    categories: scheduleViewModel.selection.categoryTokens
                )
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    filter = DeviceActivityFilter(
//                        segment: .daily(
//                            during: Calendar.current.dateInterval(
//                                of: .day, for: .now
//                            ) ?? DateInterval()
//                        ),
//                        users: .all,
//                        devices: .init([.iPhone]),
//                        applications: scheduleViewModel.selection.applicationTokens,
//                        categories: scheduleViewModel.selection.categoryTokens
//                    )
//                }
            }
    }
}

//struct MonitoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonitoringView()
//    }
//}
