<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinclude template="LOpcionesMenu.cfm">

<table width="200"  border="0" cellspacing="2" cellpadding="0">
	<cfset algunoDefinido = false>
	<cfoutput query="Menues" group="Category">
		<cfoutput group="SubCategory">
			<cfif isdefined("url.Sub#CurrentRow#")>
				<cfset algunoDefinido = true>
			</cfif>
		</cfoutput>
	</cfoutput>	
	<cfoutput query="Menues" group="Category">
		<tr>
		  <td  nowrap class="smenu1"><cfif Len(Link)><a href="#Link#" class="smenu1"></cfif>#Category#<cfif Len(Link)></a>
		  </cfif></td>
		</tr>
		<cfoutput group="SubCategory">
		<cfset CurrentLink=GetFileFromPath(Link)>
		<cfif SubCategory neq Category>
		<tr>
			<td class="smenu<cfif CurrentPage eq CurrentLink>3<cfelse>2</cfif>" ><a href="<cfif Len(Link)>#Link#<cfelse>##</cfif>" <cfif not Len(Link)>onclick="javascript:showDiv(#CurrentRow#);"</cfif> class="smenu<cfif CurrentPage eq CurrentLink>3<cfelse>2</cfif>">#SubCategory#</a></td>
		</tr>
		</cfif>
		<cfif isdefined("url.Sub#CurrentRow#") or (not algunoDefinido and Name EQ "Catálogos")>
		<cfoutput>
			<cfset CurrentLink=GetFileFromPath(Link)>
			<cfif Name neq SubCategory>
			<tr>
				<td class="smenu<cfif CurrentPage eq CurrentLink>5<cfelse>4</cfif>"><cfif Len(Link)><a a href="#Link#" class="smenu<cfif CurrentPage eq CurrentLink>5<cfelse>4</cfif>"></cfif>&nbsp;&nbsp;*&nbsp;#Name#<cfif Len(Link)></a></cfif></td>
			</tr>			
			</cfif>
		</cfoutput>
		</cfif>
		</cfoutput>
	</cfoutput>
	<script language="javascript" type="text/javascript">
		<!--//
			function showDiv(n){
				<cfoutput>
				location.href = '#CurrentPage#?Sub'+n;
				</cfoutput>
			}
			function showDiv2(n){
				alert(n);
				<cfoutput query="Menues" group="Category">
					<cfoutput group="SubCategory">
						if (#CurrentRow#==n){
							_div = document.getElementById("div_#CurrentRow#");
							alert(_div.style.display);
							if (_div.style.display == 'none') {
								_div.style.display = '';
							} else {
								_div.style.display = 'none';
							}
						}
						else
							document.getElementById("div_#CurrentRow#").style.display = 'none';
					</cfoutput>
				</cfoutput>
			}
		//-->
	</script>
	<tr>
	<td><img src="/cfmx/sif/imagenes/bottom.gif" width="100%" height="19"></td>
	</tr>
</table>