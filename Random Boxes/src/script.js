DivObject = function() {
  
  this.div = document.createElement('div');
  document.body.appendChild(this.div);
  this.div.className = "box";
  
  document.querySelectorAll( ".box" ).forEach(
      div => {
        div.style.top = parseInt(100*Math.random()) + '%';
        div.style.left = parseInt(100*Math.random()) + '%';
        div.style.width = parseInt(300*Math.random()) + 'px';
        div.style.height = parseInt(300*Math.random()) + 'px';
        div.style.transform = 'rotate(' + parseInt(360*Math.random()) + 'deg)';
        div.style.backgroundColor = 'hsla(' + parseInt(360*Math.random()) + ',' + parseInt(100*Math.random()) + '%,'+ parseInt(100*Math.random()) + '%,' + Math.random() + ')'
      }
  )  

}

