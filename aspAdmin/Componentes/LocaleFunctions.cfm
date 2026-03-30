<cfif NOT isdefined("Request.localeChange")><cfset Request.localeChange = false></cfif>
<cfset Request.fnLocaleTranslate = fnLocaleTranslate>
<cfset Request.fnLocaleConcept = fnLocaleConcept>
<cfset Request.fnLocaleChange = fnLocaleChange>
<cffunction  name="fnLocaleListConCambio" output="true">
	<cfargument name="name"      required="true" type="string">
	<cfargument name="value" 	 required="true" type="string">
	<cfargument name="Ppais"     required="true" type="string">
	<cfargument name="Icodigo"     	 required="true" type="string">
	<cfargument name="LOCcodigo" required="true" type="string">
	<cfargument name="obligatorio" required="true" type="boolean">
<cfoutput>
<cfif obligatorio><cfset obligatorio=1><cfelse><cfset obligatorio=0></cfif>
<input type="text" name="#name#" value="#value#">
<select name="cbo__#name#" id="cbo__#name#" style="display:none;" onchange="javascript:this.form.#name#.value = this.value;"></select>
<iframe name="ifr__#name#" id="ifr__#name#" style="display:none;" src="/cfmx/aspAdmin/Componentes/pLocales.cfm?Ppais=#Ppais#&Icodigo=#Icodigo#&LOCcodigo=#LOCcodigo#&name=#name#&value=#value#&obligatorio=#obligatorio#"></iframe>
<script language="JavaScript">
	var lbl__#name# ="";
	{
		var LvarLabel = document.getElementById("lbl__#name#");
		if (LvarLabel)
			lbl__#name# = LvarLabel.firstChild.nodeValue;
	}
	function #name#_cambioLocale (Ppais, Icodigo)
	{
		if (lbl__#name# == "")
		{
		}
		var LvarValue = document.getElementById("#name#").value;
		document.getElementById("ifr__#name#").src = "/cfmx/aspAdmin/Componentes/pLocales.cfm?Ppais="+Ppais+"&Icodigo="+Icodigo+"&LOCcodigo=#LOCcodigo#&name=#name#&value="+LvarValue+"&obligatorio=#obligatorio#&cambio&lblOriginal="+lbl__#name#+"&PpaisOriginal=#Ppais#";
	}
</script>
</cfoutput>
</cffunction>

<cffunction  name="fnLocaleTranslate" returntype="string" output="false">
	<cfargument name="LOEnombre"	required="true"  type="string">
	<cfargument name="LOEdefault"	required="false" type="string" 	default="">
	<cfargument name="Icodigo"		required="false" type="string" 	default="">
	<cfargument name="PorPagina"	required="false" type="boolean" default="false">
	<cfargument name="Automatico"	required="false" type="boolean" default="true">
	<cfargument name="Eliminar"		required="false" type="boolean" default="false">

	<cfif LOEdefault EQ "">
		<cfset LOEdefault = LOEnombre>
	</cfif>
	<!---
	Determina el Idioma a procesar
	--->
	<cfif Icodigo EQ "">
		<cfif isdefined("session.logonInfo")>
			<cfif isdefined("session.logonInfo.Icodigo")>
				<cfset LvarIcodigo = session.logonInfo.Icodigo>
			<cfelse>
				<cfset LvarIcodigo = "es">
			</cfif>
		<cfelse>
			<cfset LvarIcodigo = "es">
		</cfif>
	<cfelse>
		<cfset LvarIcodigo = Icodigo>
	</cfif>

	<cfquery name="rsLocale" datasource="sdc">
		select e.LOEid, t.LOTdescripcion
		  from LocaleEtiqueta e, LocaleTraduccion t
		 where e.LOEnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#LOEnombre#">
		   and e.LOEid *= t.LOEid
		   and t.Icodigo = 'es'
	</cfquery>
	<cfif rsLocale.recordCount EQ 0>
		<cfif Automatico>
			<cfquery name="rsLocale" datasource="sdc">
				declare @newLOEid numeric
				insert into LocaleEtiqueta (LOEnombre)
				values (<cfqueryparam cfsqltype="cf_sql_char" value="#LOEnombre#">)
				select @newLOEid = @@identity
				insert into LocaleTraduccion (LOEid, Icodigo, LOTdescripcion)
				values (  @newLOEid
						, 'es'
						, <cfqueryparam cfsqltype="cf_sql_char" value="#LOEdefault#">
						)
			</cfquery>
		</cfif>
		<cfset LvarEtiqueta = LOEdefault>
	<cfelseif rsLocale.LOTdescripcion EQ "">
		<cfif Automatico>
			<cfquery name="rsLocale" datasource="sdc">
				insert into LocaleTraduccion (LOEid, Icodigo, LOTdescripcion)
				values (  <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsLocale.LOEid#">
						, 'es'
						, <cfqueryparam cfsqltype="cf_sql_char" value="#LOEdefault#">
						)
			</cfquery>
		</cfif>
		<cfset LvarEtiqueta = LOEdefault>
	<cfelseif LvarIcodigo EQ "es">
		<cfset LvarEtiqueta = rsLocale.LOTdescripcion>
	<cfelse>
		<cfset LvarLOEid = rsLocale.LOEid>
		<cfset LvarEtiqueta = rsLocale.LOTdescripcion>
		<cfquery name="rsLocale" datasource="sdc">
			select LOTdescripcion
			  from LocaleTraduccion
			 where LOEid = #LvarLOEid#
			   and rtrim(Icodigo) <> 'es'
			   and charindex(rtrim(Icodigo),'#LvarIcodigo#')=1
			 order by Icodigo desc
		</cfquery>
		<cfif rsLocale.recordCount GT 0>
			<cfset LvarEtiqueta = rsLocale.LOTdescripcion>
		</cfif>
	</cfif>
	<cfreturn LvarEtiqueta>
</cffunction>

<cffunction  name="fnLocaleConcept" output="false">
	<cfargument name="LOCnombre"	required="true"  type="string">
	<cfargument name="Ppais"		required="false" type="string" 	default="">
	<cfargument name="Icodigo"		required="false" type="string" 	default="">

	<cfif Icodigo EQ "">
		<cfif isdefined("session.logonInfo")>
			<cfif isdefined("session.logonInfo.Icodigo")>
				<cfset Icodigo = session.logonInfo.Icodigo>
			<cfelse>
				<cfset Icodigo = "es">
			</cfif>
		<cfelse>
			<cfset Icodigo = "es">
		</cfif>
	</cfif>
	<cfif Ppais EQ "">
		<cfif isdefined("session.logonInfo")>
			<cfif isdefined("session.logonInfo.Ppais")>
				<cfset Ppais = session.logonInfo.Ppais>
			<cfelse>
				<cfset Ppais = "CR">
			</cfif>
		</cfif>
	</cfif>

	<cfquery name="rsLocaleTipo" datasource="sdc">
		select c.LOCtipo, c.LOCid, p.LOPid, isnull(p.LOPorden,c.LOCorden) as LOCorden, p.LOPeliminar
		  from LocaleConcepto c, LocalePais p
		 where c.LOCnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#LOCnombre#">
		   and c.LOCid *= p.LOCid
		   and p.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Ppais#">
	</cfquery>
	
	<cfquery name="rsLocaleConcept" datasource="sdc">
		set nocount on
		<cfif rsLocaleTipo.recordCount EQ 0>
			select 'N' as LOCtipo, 'no Concepto' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
		<cfelseif rsLocaleTipo.LOCtipo NEQ "I" AND Ppais EQ "">
			select 'N' as LOCtipo, 'Ppais EQ blanco' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
		<cfelseif rsLocaleTipo.LOCtipo NEQ "I" AND rsLocaleTipo.LOPid EQ "">
			select 'N' as LOCtipo, 'no Pais' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
		<cfelseif rsLocaleTipo.LOCtipo NEQ "I" AND rsLocaleTipo.LOPeliminar EQ "1">
			select 'E' as LOCtipo, 'N/A' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
		<cfelse>
			declare @Icodigo char(10)
			declare @LOCdescripcion varchar(255)
			select @Icodigo = max(Icodigo)
			  from LocaleValores
			 where LOCid = #rsLocaleTipo.LOCid#
			   <cfif rsLocaleTipo.LOCtipo NEQ "I">and LOPid = #rsLocaleTipo.LOPid#</cfif>
			   and charindex(rtrim(Icodigo),'#Icodigo#')=1
			if @Icodigo is null
			BEGIN
			<cfif Icodigo EQ 'es'>
				select 'N' as LOCtipo, 'no espanol' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
				return
			<cfelse>
				select @Icodigo = 'es'
			</cfif>
			END
			select @Icodigo = Icodigo, @LOCdescripcion = LOVdescripcion
			  from LocaleValores
			 where LOCid = #rsLocaleTipo.LOCid#
			   <cfif rsLocaleTipo.LOCtipo NEQ "I">and LOPid = #rsLocaleTipo.LOPid#</cfif>
			   and Icodigo = 'es'
			   and LOVsecuencia = 0
			if @Icodigo is null
			BEGIN
				select 'N' as LOCtipo, 'no idioma' as LOCetiqueta, null as LOVvalor, null as LOVdescripcion
				return
			END
			<cfif rsLocaleTipo.LOCtipo EQ "V">
			select '#rsLocaleTipo.LOCtipo#' as LOCtipo,
					@LOCdescripcion as LOCetiqueta,
					null as LOVvalor,
					null as LOVdescripcion
			<cfelse>
			select '#rsLocaleTipo.LOCtipo#' as LOCtipo,
					@LOCdescripcion as LOCetiqueta,
					rtrim(LOVvalor) as LOVvalor,
					LOVdescripcion
			  from LocaleValores
			 where LOCid = #rsLocaleTipo.LOCid#
			   <cfif rsLocaleTipo.LOCtipo NEQ "I">and LOPid = #rsLocaleTipo.LOPid#</cfif>
			   and Icodigo = @Icodigo
			   and LOVsecuencia <> 0
			   <cfif rsLocaleTipo.LOCorden EQ "S">
				   order by LOVsecuencia
			   <cfelseif rsLocaleTipo.LOCorden EQ "V">
				   order by LOVvalor
			   <cfelse>
				   order by LOVdescripcion
			   </cfif>
			</cfif>
		</cfif>
		set nocount off
	</cfquery>
</cffunction>

<cffunction  name="fnLocaleChange" output="true">
	<cfargument name="Icodigo"		required="false" type="string" 	default="">

	<cfif isdefined("Request.localeChange") AND Request.localeChange>
		<cfreturn>
	</cfif>

	<cfif Icodigo EQ "">
		<cfif isdefined("session.logonInfo")>
			<cfif isdefined("session.logonInfo.Icodigo")>
				<cfset Icodigo = session.logonInfo.Icodigo>
			<cfelse>
				<cfset Icodigo = "es">
			</cfif>
		<cfelse>
			<cfset Icodigo = "es">
		</cfif>
	</cfif>

	<cfset Request.localeChange = true>
<iframe id="locIfr__localeChange" style="display:none;"></iframe>

<script language="JavaScript">
	var locVar__cambioPais = "";
	function fnLocaleCambioPais (Ppais)
	{
		document.getElementById("locIfr__localeChange").src = "/cfmx/aspAdmin/Componentes/LocaleChange.cfm?Ppais="+Ppais+"&Icodigo=#Icodigo#&Campos="+escape(locVar__cambioPais);
	}
</script>
</cffunction>
