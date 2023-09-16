const modal = document.getElementById('delete');
modal.addEventListener('show.bs.modal', function (event) {
    this.querySelector('form').action = 
        event.relatedTarget.dataset.url; 
    this.querySelector('.modal-text').textContent =
        event.relatedTarget.dataset.name;
    console.log(this.querySelector('form').action);
});