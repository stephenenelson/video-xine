use Test::Pod::Coverage tests=>1;
pod_coverage_ok( "Video::Xine", { 'also_private' => [ qr/^xine_/ ]}, "Video::Xine is covered" );
