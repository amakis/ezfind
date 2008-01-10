{def $search=false()}
{if $use_template_search}
    {set $page_limit=10}
    {set $search=fetch( ezfind,search,
                        hash( 'query', $search_text,
                              'offset', $view_parameters.offset,
                              'limit', $page_limit,
                              'sort_by', hash( 'score', 'desc' ),
                              'facet', fetch( ezfind, facetParameters ),
                              'filter', fetch( ezfind, filterParameters ) ) )}
    {set $search_result=$search['SearchResult']}
    {set $search_count=$search['SearchCount']}
    {def $search_extras=$search['SearchExtras']}
    {def $facetField=$search_extras.facet_fields.0.field}
    {set $stop_word_array=$search['StopWordArray']}
    {set $search_data=$search}
{/if}
{def $baseURI=concat( '/content/search?SearchText=', $search_text )}

<script language="JavaScript" TYPE="text/javascript">
<!--{literal}
    // toggle block
    function ezfToggleBlock( id )
    {
        var value = (document.getElementById(id).style.display == 'none') ? 'block' : 'none';
		ezfSetBlock( id, value );
        ezfSetCookie( id, value );
    }

    function ezfSetBlock( id, value )
    {
		document.getElementById(id).style.display = value;
    }

    function ezfTrim( str )
    {
        return str.replace(/^\s+|\s+$/g, '') ;
    }

    function ezfGetCookie( name )
    {
	var cookieName = 'eZFind_' + name;
	var cookie = document.cookie;

	cookieList = cookie.split( ";" );

    for( var idx in cookieList )
    {
		cookie = cookieList[idx].split( "=" );

		if ( ezfTrim( cookie[0] ) == cookieName )
        {
			return( cookie[1] );
		}
	}

	return 'none';
    }

    function ezfSetCookie( name, value )
    {
	var cookieName = 'eZFind_' + name;
	var expires = new Date();

	expires.setTime( expires.getTime() + (365 * 24 * 60 * 60 * 1000));

	document.cookie = cookieName + "=" + value + "; expires=" + expires + ";";
    }
{/literal}--></script>

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-search">

<form action={"/content/search/"|ezurl} method="get">

<div class="attribute-header">
    <h1 class="long">{"Search"|i18n("design/ezwebin/content/search")}</h1>
</div>

<p>
    <input class="halfbox" type="text" size="20" name="SearchText" id="Search" value="{$search_text|wash}" />
    <input class="button" name="SearchButton" type="submit" value="{'Search'|i18n('design/ezwebin/content/search')}" />
</p>

    {def $adv_url=concat('/content/advancedsearch/',$search_text|count_chars()|gt(0)|choose('',concat('?SearchText=',$search_text|urlencode)))|ezurl}
    <label>{"For more options try the %1Advanced search%2"|i18n("design/ezwebin/content/search","The parameters are link start and end tags.",array(concat("<a href=",$adv_url,">"),"</a>"))}</label>

{if $stop_word_array}
    <p>
    {"The following words were excluded from the search"|i18n("design/base")}:
    {foreach $stop_word_array as $stopWord}
        {$stopWord.word|wash}
        {delimiter}, {/delimiter}
    {/foreach}
    </p>
{/if}

{switch name=Sw match=$search_count}
  {case match=0}
  <div class="warning">
  <h2>{'No results were found when searching for "%1".'|i18n("design/ezwebin/content/search",,array($search_text|wash))}</h2>
  {if $search_extras.hasError}
      {$search_extras.error|wash}
  {/if}
  </div>
    <p>{'Search tips'|i18n('design/ezwebin/content/search')}</p>
    <ul>
        <li>{'Check spelling of keywords.'|i18n('design/ezwebin/content/search')}</li>
        <li>{'Try changing some keywords (eg, "car" instead of "cars").'|i18n('design/ezwebin/content/search')}</li>
        <li>{'Try searching with less specific keywords.'|i18n('design/ezwebin/content/search')}</li>
        <li>{'Reduce number of keywords to get more results.'|i18n('design/ezwebin/content/search')}</li>
    </ul>
  {/case}
  {case}
  <div class="feedback">
  <h2>{'Search for "%1" returned %2 matches'|i18n("design/ezwebin/content/search",,array($search_text|wash,$search_count))}</h2>

      <fieldset>
          <legend onclick="ezfToggleBlock( 'ezfHelp' );">{'Help'|i18n( 'design/ezwebin/content/search' )} [+/-]</legend>
          <div id="ezfHelp" style="display: none;">
              {'eZ Find is a powerful search extension for eZ Publish.'|i18n( 'design/ezwebin/content/search' )}
          </div>
      </fieldset>

      <fieldset>
          <legend onclick="ezfToggleBlock( 'ezfFacets' );">{'Facets'|i18n( 'design/ezwebin/content/search' )} [+/-]</legend>
          <div id="ezfFacets" style="display: none;">
          <div class="block"><strong>{'Facets'|i18n( 'design/ezwebin/content/search' )}:</strong>&nbsp;
              {if $facetField|eq( 'class' )}
                  <span style="background-color: #F2F1ED">{'Class'|i18n( 'design/ezwebin/content/search' )}</span>
              {else}
                  <a href={concat( $baseURI, '&facet_field=class' )|ezurl}>{'Class'|i18n( 'design/ezwebin/content/search' )}</a>
              {/if}&nbsp;
              {if $facetField|eq( 'author' )}
                  <span style="background-color: #F2F1ED">{'Author'|i18n( 'design/ezwebin/content/search' )}</span>
              {else}
                  <a href={concat( $baseURI, '&facet_field=author' )|ezurl}>{'Author'|i18n( 'design/ezwebin/content/search' )}</a>
              {/if}&nbsp;
              {if $facetField|eq( 'translation' )}
                  <span style="background-color: #F2F1ED">{'Translation'|i18n( 'design/ezwebin/content/search' )}</span>
              {else}
                  <a href={concat( $baseURI, '&facet_field=translation' )|ezurl}>{'Translation'|i18n( 'design/ezwebin/content/search' )}</a>
              {/if}&nbsp;
          </div>
          <div class="block"><strong>{'Groups'|i18n( 'design/ezwebin/content/search' )}:</strong>&nbsp;
              <a href={concat( $baseURI, '&facet_field=', $facetField|wash )|ezurl}>{'All'|i18n( 'design/ezwebin/content/search' )}</a> -
              {foreach $search_extras.facet_fields.0.nameList as $facetID => $name}
                  <a href={concat( $baseURI, '&facet_field=', $facetField|wash, '&filter[]=', $search_extras.facet_fields.0.queryLimit[$facetID]|wash )|ezurl}>{$name|wash}</a>({$search_extras.facet_fields.0.countList[$facetID]})
              {delimiter}-{/delimiter}
              {/foreach}
          </div>
          </div>
      </fieldset>

  <p>{'Search time: %1 msecs'|i18n('ezfind',,array($search_extras.responseHeader.QTime|wash))}</p>

  </div>
  {/case}
{/switch}

{foreach $search_result as $result
         sequence array(bglight,bgdark) as $bgColor}
   {node_view_gui view=ezfind_line sequence=$bgColor use_url_translation=$use_url_translation content_node=$result}
{/foreach}

{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/search'
         page_uri_suffix=concat('?SearchText=',$search_text|urlencode,$search_timestamp|gt(0)|choose('',concat('&SearchTimestamp=',$search_timestamp)))
         item_count=$search_count
         view_parameters=$view_parameters
         item_limit=$page_limit}

</form>

</div>

<p class="small"><i>{$search_extras.engine}</i></p>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>


<script language="JavaScript" TYPE="text/javascript">
<!--{literal}
ezfSetBlock( 'ezfFacets', ezfGetCookie( 'ezfFacets' ) );
ezfSetBlock( 'ezfHelp', ezfGetCookie( 'ezfHelp' ) );
{/literal}--></script>