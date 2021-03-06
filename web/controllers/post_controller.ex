defmodule ShortStory.PostController do
  use ShortStory.Web, :controller

  alias ShortStory.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _) do
    posts = Repo.all(ShortStory.Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, user) do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _) do
    post = Repo.get!(ShortStory.Post, id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}, user) do
    post = Repo.get(user_posts(user), id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end
  # This is where I'd put error handling...IF I HAD SOME
  # def edit(conn, %{"id" => id}, user) do
  #   post = Repo.get(user_posts(user), id)
  #   if {Post.user_id === conn.assigns.current_user.id} do
  #     changeset = Post.changeset(post)
  #     render(conn, "edit.html", post: post, changeset: changeset)
  #   else
  #     render(conn, "show.html", post: post)
  #   end
  # end

  def update(conn, %{"id" => id, "post" => post_params}, user) do
    post = Repo.get!(user_posts(user), id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    post = Repo.get!(user_posts(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp user_posts(user) do
    assoc(user, :posts)
  end
end
