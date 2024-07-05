import SwiftUI


// Sample available goals array
let availableGoals: [Goal] = [
    Goal(title: "Deepen your self-understanding", imageName: "deepenYourSelfUnderstanding_Goal", imgColor: Color("color1")),
    Goal(title: "Ignite your motivation", imageName: "igniteYourMotivation_Goal", imgColor: Color("color1")),
    Goal(title: "Expand your skills and knowledge", imageName: "expandYourSkillsAndKnowledge_Goal", imgColor: Color("color1")),
    Goal(title: "Overcome challenges", imageName: "overcomeChallenges_Goal", imgColor: Color("color1")),
    Goal(title: "Enhance relationships and communication", imageName: "enhanceRelationshipAndCommunication_Goal", imgColor: Color("color1")),
    Goal(title: "Discover inner peace and happiness", imageName: "discoverInnerPeaceAndHappiness_Goal", imgColor: Color("color1"))
]

struct BookRowView: View {
    let book: Book
    
    var body: some View {
            HStack() {
                if book.isPinned {
                  Image(systemName: "pin.fill")
//                        .foregroundColor(.color2)
                }
                if let photoData = book.bookCover, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                VStack(alignment: .leading) {
                    HStack (spacing : 5 ){
//                        .padding (.horizontal, 2)
                        Text(book.title)
                            .font(.title3)
                            .bold()
                            .fontDesign(.serif)
                        
                    }
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontDesign(.serif)
                    
                    
                    Spacer()
                    // Display goals below the author as image
                    HStack (spacing : -5) {
                        ForEach(book.goals, id: \.self) { goalTitle in
                            if let goal = availableGoals.first(where: { $0.title == goalTitle }) {
                                Image(goal.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
//                                    .background(goal.imgColor)
//                                    .clipShape(Circle())
                            } else {
                                Text(goalTitle) // Fallback if goal is not found
                                    .font(.footnote)
                            }
                        }
                        
                    }
                    .padding (.horizontal, 2)
                }
                .padding(.vertical, 8)
            
                
                Spacer()
                
                Text("\(book.notes?.count ?? 0)")
                    .foregroundColor(.secondary)
            }
    }
}

//#Preview {
//    BookRowView(book: Book(title: "hamo", author: "hamo", goals: ["Hamooo"], isPinned: false))
//}
