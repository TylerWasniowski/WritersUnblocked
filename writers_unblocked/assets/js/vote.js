export var Vote = {
    armVoting: function() {
        document.addEventListener('DOMContentLoaded', function() {
            // If user has already voted, don't arm vote icons
            if (document.querySelector('.voted-icon'))
                return;

            document.querySelectorAll('.story')
                .forEach(
                    (storyDiv) =>
                    {
                        const voteDiv = storyDiv.querySelector('.vote-icon')
                        if (!voteDiv)
                            return;

                        const storyId = storyDiv.getAttribute('id')
                        let data = new FormData()
                        data.append('id', storyId)

                        voteDiv.addEventListener('click', (event) => {
                            fetch('/vote', {
                                method: 'post',
                                credentials: 'same-origin',
                                headers: {
                                    "X-CSRF-Token": CSRF_TOKEN
                                },
                                body: data
                            })
                            .then(() => {                                
                                voteDiv.classList.remove('vote-icon')
                                voteDiv.classList.add('voted-icon')
                                
                                const voteDivs = document.querySelectorAll('.vote-icon')
                                voteDivs.forEach(
                                    (element) => {
                                        // Removes event handlers from other voting divs
                                        element.outerHTML = element.outerHTML
                                    }
                                )
                            })
                        })
                    }
                )
        })
    }
}