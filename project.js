//http://net.tutsplus.com/tutorials/javascript-ajax/from-jquery-to-javascript-a-reference/

onload = function() {
    var commits = document.querySelector('#nav-commits');
    var user = document.querySelector('#nav-user');
    
    var commitsSection = document.querySelector('section#commits');
    var userSection = document.querySelector('section#users');
    
    //setup click event handler
    commits.addEventListener('click', navigateToCommits);
    user.addEventListener('click', navigateToUser);

    //navigate to selected page on browser reload
    location.hash.substring(1) == 'user' ? navigateToUser() : navigateToCommits();        
    

    //helpers
    function navigateToCommits() {
         user.classList.remove('active');
         userSection.classList.add('hidden');
         
         commits.classList.add('active');
         commitsSection.classList.remove('hidden');
    }

    function navigateToUser() {
        commits.classList.remove('active');
        commitsSection.classList.add('hidden');
        
        user.classList.add('active');
        userSection.classList.remove('hidden');
    }
}

