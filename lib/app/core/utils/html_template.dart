const String htmlTemplate = '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>com_joaojsrbr_reader</title>

    <style>
      * {
        margin: 0;
        padding: 0;
      
        box-sizing: border-box;
      }
      

      body {
        width: 100%;
        min-height: 100vh;
        padding-top 24px;

        display: flex;
        flex-direction: column;
      }

      body > div,
      img {
        width: 100%;
      }

      p {
        width: 100%;
        padding: 18px 24px;
        background-color: #000;
        

        color: #fff;
        font-size: 20px;
        text-align: center;
        font-weight: 500;
      }

      #loading {
        width: 100%;
        height: 100vh;
        z-index: 2;

        top: 0;
        left: 0;
        position: fixed;

        display: flex;
        align-items: center;
        justify-content: center;

        backdrop-filter: blur(2.5px);
        background-color: rgba(0, 0, 0, 0.01);
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      .loading-indicator {
        width: 48px;
        height: 48px;

        border: 5px solid rgba(63, 81, 181, 0.2);
        border-top: 5px solid rgb(63, 81, 181);
        border-radius: 50%;

        animation: spin 0.8s linear infinite;
        background-color: transparent;
      }
    </style>
  </head>
  <body>
    <div id="root"></div>

    <div id="loading">
      <div class="loading-indicator"></div>
    </div>

    <script>
      function insertFinish() {

        const title = document.createElement('p');
        title.innerText = 'Não há mais capítulos no memento.';

        const container = document.createElement('div');
        container.append(title);

        document.querySelector('#root').appendChild(container);
      }

      function insertContent(data, id, name) {
        const container = document.createElement('div');

        const title = document.createElement('p');
        title.innerText = name;
        title.setAttribute("id", "title")

        container.append(title);

        let finished = false;
        let loaded = 0;
        let callNext = false;
        const sources = data.split(',,separator,,');

        for (const src of sources) {
          
          if(!src.includes("https")){

          const content = document.createElement('p');
          content.innerText = src;
          content.setAttribute('style', 'padding: 8px 10px;display: block;text-align: justify;font-size: 14px;font-family: poppins,sans-serif;margin-block-start: 1em;margin-block-end: 1em;margin-inline-start: 0px;margin-inline-end: 0px;background-color: rgb(16, 16, 20);');
          
           container.append(content);
           onLoad.postMessage('');
          } else {
          const content = document.createElement('img');
          content.setAttribute('src', src);
          content.addEventListener('load', () => {
            if (!content.complete) return;

            loaded++;
            if (loaded === sources.length) onLoad.postMessage('');
          });
           container.append(content);
          }


        
        }

        function scroll() {
          const { top, height } = container.getBoundingClientRect();
          if (top > 0) return;

          const position = top * -1;
          const minRead = (25 / 100) * height;
          const minNext = (75 / 100) * height;
          const max = height * 1.25;

          if (position >= height && !finished) {
            finished = true;
            onFinished.postMessage(`\${id},,\${height}`);
          }

          if (position >= minNext && !callNext) {
            callNext = true;        
            onNext.postMessage('');
          }

          if (position <= height && position > 0) {
            onPosition.postMessage(`\${id},,\${position}`);
          }

          if (position >= max) {
            window.removeEventListener('scroll', scroll);
            container.remove();
          }
        }

        window.addEventListener('scroll', scroll);

        document.querySelector('#root').appendChild(container);
      }
    </script>
  </body>
</html>
''';
