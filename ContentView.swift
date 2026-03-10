import SwiftUI

// 1. Vista Principal que contiene la estructura de la App
struct ContentView: View {
    @State private var apps: [AppModel] = []
    @State private var selectedTab: String? = "Discover"
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedTab: $selectedTab)
        } detail: {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    Text(selectedTab ?? "Better Store")
                        .font(.largeTitle).bold()
                    
                    if selectedTab == "Discover" {
                        DiscoverView(apps: apps)
                    } else {
                        Text("Contenido para \(selectedTab ?? "")")
                            .frame(maxWidth: .infinity, minHeight: 400)
                    }
                }
                .padding(30)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear(perform: cargarApps)
    }

    func cargarApps() {
        guard let url = Bundle.main.url(forResource: "apps", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }
        self.apps = (try? JSONDecoder().decode([AppModel].self, from: data)) ?? []
    }
}

// 2. Barra Lateral de Navegación
struct SidebarView: View {
    @Binding var selectedTab: String?
    
    var body: some View {
        List(selection: $selectedTab) {
            Section {
                NavigationLink(value: "Discover") { Label("Discover", systemImage: "star") }
                NavigationLink(value: "Arcade") { Label("Arcade", systemImage: "gamecontroller") }
                NavigationLink(value: "Create") { Label("Create", systemImage: "pencil.tip") }
                NavigationLink(value: "Work") { Label("Work", systemImage: "briefcase") }
            }
        }
    }
}

// 3. Vista de Descubrimiento (Grid de Apps)
struct DiscoverView: View {
    let apps: [AppModel]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(apps) { app in
                AppRow(app: app)
            }
        }
    }
}

// 4. Fila de diseño profesional (El diseño "App Store")
struct AppRow: View {
    let app: AppModel
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: app.urlIcono)) { image in
                image.resizable().frame(width: 50, height: 50).cornerRadius(12)
            } placeholder: {
                Color.gray.frame(width: 50, height: 50).cornerRadius(12)
            }
            
            VStack(alignment: .leading) {
                Text(app.nombre).font(.headline)
                Text(app.tipo).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Button("Get") {}.buttonStyle(.borderedProminent)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
    }
}
