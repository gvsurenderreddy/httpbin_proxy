package MojoTest2::Controller::Httpbin;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Path;

has 'httpbin_url' => sub {
    return Mojo::URL->new('http://httpbin.org');
};

sub proxy {
    my $self = shift;
    $self->delay(
        sub {
            my $delay = shift;
            my $path
                = Mojo::Path->new( $self->stash('path') )->leading_slash(1);
            my $method = $self->req()->method();
            $self->ua->get(
                $self->httpbin_url()->path($path) => $delay->begin() );
            return;
        },
        sub {
            my ( $delay, $tx ) = @_;
            $self->render(
                data   => $tx->res->body,
                status => $tx->res->code,
                format => 'json'
            );
        }
    );
    return;
}
1;
