<!--- 
	Modificado por: Ana Villavicencio R.
	Fecha: 12 de julio del 2005
	Motivo: No funcionaba cuando se digitaba la identificación del socios de negocios.  
			No hacia la actualización de los diferentes campos relacionados con el socio
			de negocios
 --->

	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="SNnombre">
	<cfparam name="url.identificacion" default="SNidentificacion">
	<cfparam name="url.numero" default="SNnumero">
	<cfparam name="url.id" default="SNcodigo">
	<cfparam name="url.FuncJSalCerrar" default="FuncJSalCerrar">
		
	<cfif isdefined("url.numero") and url.numero NEQ "">
		<cfquery name="rs" datasource="#Session.DSN#">			
			select * 
			from SNegocios a, EstadoSNegocios b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and a.SNinactivo = 0
			  and a.ESNid = b.ESNid
	  		  and b.ESNfacturacion = 1
		  	<cfif url.tipo EQ "P">
			  and SNtiposocio != 'C'
			<cfelseif url.tipo EQ "C">
			  and SNtiposocio != 'P'
			</cfif>	  
		    <cfif isdefined("url.numero") and (url.numero NEQ "")>
		  	  and upper(ltrim(rtrim(SNnumero))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(url.SNnumero))#"> 
			</cfif>
		</cfquery>

		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.identificacion#</cfoutput>.value="<cfoutput>#rs.SNidentificacion#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.numero#</cfoutput>.value="<cfoutput>#rs.SNnumero#</cfoutput>";
			<cfoutput>if (window.parent.func#url.id#){ window.parent.func#url.id#()}</cfoutput> 

		</script>

	</cfif>