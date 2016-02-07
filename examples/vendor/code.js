// Extract the source code from a tag and place it in a <pre><code>source</code></pre> tag
function codify(selector, targetSelector, preClass) {
  var element = document.querySelector(selector)
  var target = document.querySelector(targetSelector)
  var html = element.innerHTML
            .trim()
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")

  var code = document.createElement("code")
  code.innerHTML = html

  var pre = document.createElement("pre")
  pre.classList.add(preClass)
  pre.appendChild(code)
  target.appendChild(pre)
}
