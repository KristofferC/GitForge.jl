"""
A forge is an online platform for Git repositories.
The most common example is [GitHub](https://github.com).

`Forge` subtypes can access their respective web APIs.
"""
abstract type Forge end

"""
    Endpoint(
        method::Symbol,
        url::AbstractString;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::Dict=Dict(),
    ) -> Endpoint

Contains information on how to call an endpoint.

## Arguments
- `method::Symbol`: HTTP request method to use.
- `url::AbstractString`: Endpoint URL, relative to the base URL.

## Keywords
- `headers::Vector{<:Pair}=HTTP.Header[]`: Request headers to add.
- `query::Dict=Dict()`: Query string parameters to add.
"""
struct Endpoint
    method::Symbol
    url::String
    headers::Vector{<:Pair}
    query::Dict

    function Endpoint(
        method::Symbol, url::AbstractString;
        headers::Vector{<:Pair}=HTTP.Header[], query::Dict=Dict(),
    )
        return new(method, url, headers, query)
    end
end

"""
    base_url(::Forge) -> String

Returns the base URL of all API endpoints.
"""
base_url(::Forge) = ""

"""
    request_headers(::Forge, ::Function) -> Vector{Pair}

Returns the headers that should be added to each request.
"""
request_headers(::Forge, ::Function) = ["User-Agent" => USER_AGENT[]]

"""
    request_query(::Forge, ::Function) -> Dict

Returns the query string parameters that should be added to each request.
"""
request_query(::Forge, ::Function) = Dict()

"""
    request_kwargs(::Forge, ::Function) -> Dict{Symbol}

Returns the extra keyword arguments that should be passed to `HTTP.request`.
"""
request_kwargs(::Forge, ::Function) = Dict()

"""
    postprocessor(::Forge, ::Function) -> Type{<:PostProcessor}

Returns the [`PostProcessor`](@ref) to be used.
Type parameters must not be included (they are produced by [`into`](@ref)).
"""
postprocessor(::Forge, ::Function) = DoNothing

"""
    into(::Forge, ::Function) -> Type

Returns the type that the [`PostProcessor`](@ref) should create from the response.

"""
into(::Forge, ::Function) = Nothing

"""
    endpoint(::Forge, ::Function, args...) -> Endpoint

Returns an [`Endpoint`](@ref) for a given function.
Trailing arguments are usually important for routing.
For example, [`get_user`](@ref) can take some ID parameter which becomes part of the URL.
"""
endpoint(f::T, ::Function, args...) where T <: Forge =
    error("$T has not implimented this function")

"""
    rate_limit_check(::Forge, ::Function) -> Bool

Returns whether or not there is an active rate limit.
If one is found, [`on_rate_limit`](@ref) is called to determine how to react.
"""
rate_limit_check(::Forge, ::Function) = false

"""
    on_rate_limit(::Forge, ::Function) -> OnRateLimit

Returns an [`OnRateLimit`](@ref) that determines how to react to an exceeded rate limit.
"""
on_rate_limit(::Forge, ::Function) = ORL_RETURN

"""
    rate_limit_wait(::Forge, ::Function)

Wait for a rate limit to expire.
"""
rate_limit_wait(::Forge, ::Function) = nothing

"""
    rate_limit_period(::Forge, ::Function) -> Period

Compute the amount of time until a rate limit expires.
"""
rate_limit_period(::Forge, ::Function) = nothing

"""
    rate_limit_update!(::Forge, ::Function, ::HTTP.Response)

Update the rate limiter with a new response.
"""
rate_limit_update!(::Forge, ::Function, ::HTTP.Response) = nothing
