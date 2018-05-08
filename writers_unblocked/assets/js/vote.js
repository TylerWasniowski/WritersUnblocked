export var Vote = {
    armVoting: function() {
        document.addEventListener('DOMContentLoaded', function() {
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

                        const storiesDiv = document.querySelector('#stories')
                        voteDiv.addEventListener('click', (event) => {
                            // Don't do anything if user already used all votes
                            if (storiesDiv.classList.contains('all-votes-used'))
                                return;
                                
                            fetch('/vote', {
                                method: 'post',
                                credentials: 'same-origin',
                                headers: {
                                    "X-CSRF-Token": CSRF_TOKEN
                                },
                                body: data
                            })
                            .then((response) => {                     
                                voteDiv.classList.remove('vote-icon')
                                voteDiv.classList.add('voted-icon')
                                
                                response.json().then(
                                    (json) => {
                                        if (json.allVotesUsed)
                                            storiesDiv.classList.add('all-votes-used')
                                    }
                                )
                            })
                        })
                    }
                )
        })
    }
}