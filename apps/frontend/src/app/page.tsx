export default function HomePage() {
  return (
    <div className="container mx-auto px-4 py-16">
      <div className="text-center">
        <h1 className="text-6xl font-bold text-gray-900 mb-6">
          Hello World! 🚀
        </h1>
        <h2 className="text-3xl font-semibold text-indigo-600 mb-8">
          Welcome to ContribPortal
        </h2>
        <p className="text-xl text-gray-700 max-w-2xl mx-auto mb-12">
          A platform for discovering open source contribution opportunities.
          Find projects that match your skills and start contributing to the open source community.
        </p>
        
        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-4">🎯 For Contributors</h3>
            <p className="text-gray-600">
              Discover projects that match your skills and interests. Filter by language, 
              difficulty level, and contribution type to find the perfect first issue.
            </p>
          </div>
          
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-4">🏗️ For Maintainers</h3>
            <p className="text-gray-600">
              Connect with contributors looking to help. Tag your issues appropriately 
              and watch your project grow with quality contributions.
            </p>
          </div>
        </div>
        
        <div className="mt-16">
          <a 
            href="/explore" 
            className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200"
          >
            Start Exploring Projects
          </a>
        </div>
      </div>
    </div>
  )
}