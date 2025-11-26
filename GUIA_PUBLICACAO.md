# 📝 Guia de Publicação - Feline Living Collective

Este guia explica como criar e publicar novos artigos no seu blog.

---

## 🚀 Opção 1: Converter do Medium (Recomendado)

Se você já escreve no Medium, este é o jeito mais fácil.

1.  **Exporte seus dados do Medium**:
    *   Vá em *Settings > Download your information*.
    *   Baixe e extraia o arquivo `.zip`.
    *   Pegue os arquivos `.html` da pasta `posts`.

2.  **Coloque na pasta do projeto**:
    *   Copie os arquivos `.html` para a pasta: `F:\Blog netfly\feline-living-collective\medium-export`

3.  **Execute o Conversor**:
    *   Abra o terminal na pasta do projeto.
    *   Execute:
        ```powershell
        .\convert-medium.ps1
        ```
    *   *Nota: Se as imagens falharem, o script usará os links originais do Medium automaticamente.*

4.  **Verifique**:
    *   O novo post aparecerá em `content/posts/`.
    *   Abra o arquivo `.md` e confira se está tudo certo.

---

## ✍️ Opção 2: Criar Manualmente

Para escrever um artigo do zero.

1.  **Crie o arquivo**:
    *   Vá na pasta `content/posts`.
    *   Crie um arquivo novo, ex: `meu-novo-post.md`.

2.  **Adicione o Cabeçalho (Frontmatter)**:
    Cole isso no topo do arquivo e edite:

    ```yaml
    ---
    title: "Título do Seu Artigo"
    date: 2025-11-26
    description: "Uma breve descrição que aparece no Google e no card do post."
    image: "https://link-da-imagem.com/foto.jpg"  # Ou "/images/minha-foto.jpg" se for local
    canonicalUrl: "" # Opcional: Link original se veio de outro lugar
    ---
    ```

3.  **Escreva o Conteúdo**:
    *   Use Markdown normal.
    *   Para **Imagens**, use nosso shortcode especial:
        ```markdown
        {{< img src="https://link-da-imagem.com/foto.jpg" alt="Descrição da foto" >}}
        ```
    *   Para **Produtos (Amazon)**:
        ```markdown
        {{< product link="https://amazon..." img="https://..." name="Nome do Produto" price="$99" >}}
        ```

---

## 🖼️ Sobre Imagens

Você tem duas opções:

1.  **Link Direto (Mais Fácil)**:
    *   Pegue o link da imagem (do Medium, Unsplash, etc).
    *   Cole direto no `src`.
    *   *Vantagem*: Não ocupa espaço no seu computador.

2.  **Arquivo Local**:
    *   Salve a imagem na pasta `static/images`.
    *   No post, use apenas o nome do arquivo: `src="minha-foto.jpg"`.
    *   *Vantagem*: Mais rápido e seguro se o link original cair.

---

## 👀 Como Testar (Preview)

Antes de publicar, veja como ficou:

1.  Abra o terminal na pasta do projeto.
2.  Rode:
    ```bash
    hugo server
    ```
3.  Acesse `http://localhost:1313` no navegador.

---

## 🌍 Como Publicar (Deploy)

Quando estiver pronto, mande para o ar:

1.  **Abra o GitHub Desktop** (ou use o terminal).
2.  **Commit**:
    *   Escreva um resumo (ex: "Novo post sobre Gatos").
    *   Clique em "Commit to main".
3.  **Push**:
    *   Clique em "Push origin".

🎉 **Pronto!** O Netlify vai detectar a mudança e atualizar o site em ~1 minuto.
Acesse: https://felinelivingcollective.netlify.app
