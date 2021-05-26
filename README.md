# Spacescape

<h3> A simple NASA image library search app </h3>

![Screenshot](Screenshots/Spacescape.png)

<h3> Architecture </h3>
MVC pattern was used to create this app

- Model:
  - NASAClient: responsible for making network calls to the NASA Images search API
  - SearchResult: gets populated with data from network calls
  
- View:
  - SearchResultTableViewCell: custom cell that display information about a search 
  - TitleLabel, DateLabel, DescriptionLabel: custom labels
  - SearchResultImage: custom image view
  
- View Controller:
  - SearchViewController: handles search bar functionality and communicates with SearchResultsTableViewController to respond to row selection/fetching more results
  - SearchResultsTableViewController: displays search results in a vertical scrollable list
  - InfoViewController: displays detailed information about a search result

<h3> 3rd Party Libraries </h3>
SnapKit was used to programmatically set Auto Layout constraints. Using SnapKit makes it easy to setup constraints in a simple and expressive way. 

<h3> Development </h3>

Requirements: 
- Xcode 12.3+
- iOS 14.3+

Clone the repo, build and run in Xcode. 

<h3> Credits </h3>

- NASA Images from: https://images.nasa.gov/
- Images by <a href="https://icons8.com/">Icons8</a> 
