using JuMP
import MathOptInterface
using DataStructures
## Abstract types declaration
abstract type Coordinate end
## ":: is an instance of"; assert the value of the expression on the left is an instance of the type on the right.
## if the type assertion is not true, an exception is thrown, otherwise, the left-hand value is returned.
## Parametric Composite Types
## Type parameters in {}
struct Station{T<:Coordinate} ## <: indicating the newly declared abstract type is a subtype of this "parent" type
    id::Int
    coordinate::T
    label::String
    is_dummy::Bool
end

struct GeoCoordinate <: Coordinate
    latitude::Float64
    longitude::Float64
end

struct EuclideanCoordinate <: Coordinate
    x::Real
    y::Real
end

const GeoStation = Station{GeoCoordinate}
const EuclideanStation = Station{EuclideanCoordinate}

struct Line
    id::String
end

abstract type GenericEdge{TS<:Station} end

struct Edge{TS} <: GenericEdge{TS}
    from::TS
    to::TS
    line::Line
end

const GeoEdge = Edge{GeoStation}
const EuclideanEdge = Edge{EuclideanStation}

# TODO: How to make sure that station and edges refer to the same station type?
struct TransitMap{TS<:Station, TE<:GenericEdge}
    stations::Array{TS}
    edges::Array{TE}
    lines::Array{Line}
end

#@enum Direction North=2 NorthEast=1 East=0 SouthEast=7 South=6 SouthWest=5 West=4 NorthWest=3
const Direction = Int

struct ProcessedEdge{TS} <: GenericEdge{TS}
    from::TS
    to::TS
    line::Line
    direction::Direction
    min_length::Int
    is_single_label_edge::Bool
end

const GeoTransitMap = TransitMap{GeoStation, GeoEdge}

const InputGraph = TransitMap{EuclideanStation, ProcessedEdge{EuclideanStation}}

# output

struct TransitMapLayout
    stations::Array{EuclideanStation}
    edges::Array{Edge{EuclideanStation}}
    lines::Array{Line}
    faces::Set{Set{ProcessedEdge{EuclideanStation}}}
end

struct ModelVariables
    x::Any
    y::Any
end
