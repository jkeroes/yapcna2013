#!/user/bin/env perl
use Mojolicious::Lite;

my $data = [
{id => 1, title => 'Jane\'s Talk'},
{id => 2, title => 'Elane\'s Talk'},
{id => 3, title => 'Gilbert\'s Talk'}
];

get '/' => 'index';

get '/api' => sub {
    my $self = shift;
    $self->render_json({collection => $data});
};

get '/api/:id' => sub {
    my $self = shift;
    my $id   = int $self->param('id');
    if ($id > 0 && $id < 4) {
    	my $hash = $data->[$id - 1];
    	$self->render(json => $hash);
    }
    else {
	$self->render(json => {error => "Not Found"}, status => 404);
    }
};

app->secret('welcome to the clown car, bro');
app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html lang="en">
<head>
<title>Mojo World</title>
<link rel="stylesheet" href="/app.css">
</head>
<body>
<h1>Something Something</h1>
<div id="content">
Loading...
</div>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.7.2/mustache.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js"></script>
<script src="/app.js"></script>
</body>
</html>