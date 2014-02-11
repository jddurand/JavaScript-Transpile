#
# On tricky thing in JavaScript is the this variable.
# It is global in the sense that this is always available, but context dependent.
#
# We solve it by using a localized variable $JavaScript::Transpile::Target::Perl5::Engine::this, embedded
# in the role 
#
