-module(geometry).
-export([perimeter/1]).

perimeter({circle, Radius}) ->
	2 * 3.1415926 * Radius;
perimeter({triangle, Length, Width, Height}) ->
	Length + Width + Height.

