export var Vote = {
    armVoting: function() {
        document.addEventListener('DOMContentLoaded', function() {
            document
                .querySelectorAll('.story')
                .forEach(
                    (storyDiv) =>
                    {
                        const storyId = storyDiv.getAttribute('id')
                        const voteDiv = storyDiv.querySelector('.vote-icon')

                        let data = new FormData()
                        data.append('id', storyId)

                        voteDiv.addEventListener('click', function (event) {
                            fetch('/vote', {
                                method: 'post',
                                credentials: 'same-origin',
                                headers: {
                                    "X-CSRF-Token": CSRF_TOKEN
                                },
                                body: data
                            })
                        })
                    }
                )
        })
    }
}