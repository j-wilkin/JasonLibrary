# Jason Library #

This is a simple library app I built for a coding test. When connected to an API that supports GET/ADD/UPDATE/DELETE endpoints, it can:
* Add new books
* Update existing book information
* Update a book's checkout information
* Delete books

Without the API it can still scan book ISBN barcodes to autofill book info.

### Dependencies ###
* Alamofire
* SwiftyJSON
* Google Books API

### API ###

I built my API using Alamofire's Router model and using completion handlers for each kind of request. I think the enum router is a very clean and simple model for how an app creates its requests. I was able to have the endpoint paths and CRUD methods linked to each enum case.

I preferred completion handlers so that I could easily create requests when and where I needed to in code. In some more complex architectures, using delegates or a reactive style may be more advantageous. But I think this implementation works nicely for a smaller app with a few types of requests.

### Models ###

I used a pretty simple Book model with SwiftyJSON to parse the data. I made lastCheckedOut and lastCheckedOutBy optional strings because these would be initialized as "null" in the API when creating a new book.

I keep all of the data centralized in the BookDataStore singleton and all requests to get/add/update/delete a book must come through this class. I prefer to keep the data in one place in the app and pass it out to the views as necessary.

### Add/Update Book Form ###

I created a separate class for the form view to handle validation/form processing and all text field view logic. This allowed me to keep the AddBookViewController lightweight and focused on the top-level view controller tasks. The ValidationErrors enum can easily be extended to handle more validation errors for the form. The FormProtocol can also be reused with other forms. To improve this, I could have brought prepopulateFields() and setup() into the protocol and tried to completely separate the view controller from the form class. I used inheritance for the UpdateBookViewController since these view controllers are functionally very similar.

### Book Detail ###

The BookDetail view controller simply displays the fields and supports checkout/updating/sharing. I decided to keep the category & publisher labels in the view even when these fields are empty to encourage filling out the full form. I could have used extra constraints with a lower priority and removed the labels to have them move up automatically, but I needed to support hiding/showing these after a user updates a book.

### Barcode Scanner ###

I decided to have a little fun with this and add a barcode scanner to autofill the form. I had never used the AVCapture APIs before, so this was a nice way to try something new. It will sometimes take a couple of tries/a bit of wiggling to get it to recognize the barcode, but I think it works pretty well! I used the Google Books API for grabbing book metadata because it was free and I figured Google must have a nice dataset to work with. Although it doesn't find metadata for every book in my library, I think it worked out pretty well. This is the Objective-C part of the app because it works relatively independently, only needing one delegate method to fire back the book metadata.

### Room for Improvement ###

Here are a few features I would add:

* Sorting (last checked out/alphabetically/categories)
* Search (name/category)
* Sliding tableview cell right for checkout
* Returning a book/disallow checkout until returned