import UIKit

class RecipeScreen: UIView {
    
    let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "default_recipe_image") 
        return imageView
    }()
    
    let recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Recipe Name: Egg Potatoes"
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return textField
    }()
    
    let ingredientsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.text = "List ingredients:Eggs and Potatoes"
        return textView
    }()
    
    let instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.text = "Add cooking steps: first eggs then potatoes"
        return textView
    }()
    
    let recipeTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Recipe type:Chinese Dishes"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var menuButton: UIButton = createBarButton(imageSystemName: "line.horizontal.3")
    private lazy var searchButton: UIButton = createBarButton(imageSystemName: "magnifyingglass")
    private lazy var homeButton: UIButton = createBarButton(imageSystemName: "house")
    private lazy var profileButton: UIButton = createBarButton(imageSystemName: "person.crop.circle")
    private lazy var addButton: UIButton = createPlusButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBarButton(imageSystemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func createPlusButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func addBorderLine(to view: UIView) {
        let borderLine = UIView()
        borderLine.backgroundColor = .lightGray
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLine)

        NSLayoutConstraint.activate([
            borderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func addBorderLineToTopOfBottomBar() {
        let borderLine = UIView()
        borderLine.backgroundColor = .lightGray
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(borderLine)

        NSLayoutConstraint.activate([
            borderLine.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            borderLine.topAnchor.constraint(equalTo: bottomBar.topAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func addSubviews() {
        backgroundColor = .white
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(recipeImageView)
        addSubview(recipeNameTextField)
        addSubview(ingredientsTextView)
        addSubview(instructionsTextView)
        addSubview(recipeTypeTextField)
        
        topBar.addSubview(menuButton)
        topBar.addSubview(searchButton)
        
        bottomBar.addSubview(homeButton)
        bottomBar.addSubview(profileButton)
        bottomBar.addSubview(addButton)
        
        addBorderLine(to: topBar)
        addBorderLineToTopOfBottomBar()
    }
    
    private func setupConstraints() {
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        recipeTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        topBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50),
            
            menuButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            menuButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 24),
            menuButton.heightAnchor.constraint(equalToConstant: 24),
            
            searchButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
            recipeImageView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 16),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            recipeNameTextField.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            recipeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            ingredientsTextView.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 16),
            ingredientsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ingredientsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            instructionsTextView.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 16),
            instructionsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            instructionsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            instructionsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            recipeTypeTextField.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 16),
            recipeTypeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeTypeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeTypeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 70),
            
            homeButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 32),
            homeButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            profileButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -32),
            profileButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            addButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -30),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

