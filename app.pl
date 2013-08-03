#!/user/bin/env perl
use Mojolicious::Lite;

# We'll define some data here that our API will return

my $data = {
    1 => {title => q(Jane's Talk),     boring=>1, length=>2.0 },
    2 => {title => q(Elane's Talk),    boring=>0, length=>1.0 },
    3 => {title => q(Gilbert's Talk),  boring=>1, length=>0.5 },
    4 => {title => q(Humberto's Talk), boring=>0, length=>1.0 },
    5 => {title => q(Ameera's Talk),   boring=>0, length=>1.0 },
    6 => {title => q(Xue's Talk),      boring=>1, length=>0.25}
};

# check if this is request from pjax, if so, then don't use a layout
# see https://gist.github.com/taiju/2382076

under sub {
    my $self = shift;
    my $is_pjax = $self->param('_pjax') ? 1 : 0;
    $self->layout('default') unless $self->req->is_xhr || $is_pjax;
};

# routes

# a request to / returns a list of talks

get '/' => sub {
    my $self = shift;
    my $wanted = [
      map { { 'id' => $_,
              'title' => $data->{$_}->{title} } }
      keys %$data
    ];
    $self->stash(collection => $wanted);
    $self->render('index');
};

# a request to /item/:id returns one of the hashes in $data, 
# otherwise return a 404 response

get 'item/:id' => sub {
    my $self = shift;
    my $id   = int $self->param('id');
    my $size = scalar (keys %$data);
    my $prev = $id - 1;
    if ($prev < 1) {
      $prev = $size;
    }

    if (exists $data->{$id}) {
      my $hash = $data->{$id};
      $hash->{id} = $id;
      $hash->{next} = ($id % $size) + 1;
      $hash->{prev} = $prev;
      $self->stash(item => $hash);
      $self->render('detail');
    }
    else {
      $self->render(status => 404);
    }
};

app->secret('welcome to the clown car, bro');
app->start;
__DATA__

@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="en">
<head>
<title>Mojo/Pjax Demo</title>
<link rel="stylesheet" href="/app.css">
</head>
<body>
<h1>Schedule</h1>
<div id="content">
    <%= content %>
</div>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery.pjax/1.7.0/jquery.pjax.min.js"></script>
<script src="/app.js"></script> 
</body>
</html>

@@ index.html.ep
<ul>
% for my $item (@$collection) {
    <li><a href="/item/<%= $item->{id} %>"><%= $item->{title} %></a></li>
% }
    <li><a href="/item/3000">Fake Item</a></li>
</ul>

@@ detail.html.ep
<p>Title: <%= $item->{title} %>, <%= $item->{length} %> hours</p>
<p><a href="/item/<%= $item->{prev} %>">Previous</a> | <a href="/">Home</a> | <a href="/item/<%= $item->{next} %>">Next</a></p>

@@ not_found.development.html.ep
<p>This item doesn't exist.</p>
<p><a href="/">Home</a></p>

