<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfparam name="url.IACcampo" default="IACinventario">
<cfparam name="url.SNid" default="-1">
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfif find("Cformato", url.IACcampo)>
		<!--- Cuando el IACcampo es CformatoIngresos o CformatoCompras, se debe sustituir la mascara con el complemento del Socio de Negocio --->
		<cfif NOT (isdefined("url.Almacen") and len(trim(url.Almacen)) )>
			<cfset fnmessage("Para obtener el '#url.IACcampo#' se requiere el Almacen")>
		<cfelseif url.SNid EQ "-1">
			<cfset fnmessage("Para obtener el '#url.IACcampo#' se requiere el Socio de Negocio (SNid)")>
		</cfif>

		<cfquery name="rsSQL" datasource="#url.conexion#">
			select #url.IACcampo# as Formato
			  from Articulos a
				inner join Existencias b
					 on b.Ecodigo=a.Ecodigo
					and b.Aid=a.Aid
				inner join IAContables c
					 on c.IACcodigo = b.IACcodigo
					and c.Ecodigo = b.Ecodigo
			 where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			   and upper(rtrim(ltrim(a.Acodigo)))=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(url.dato))#">
			   and b.Alm_Aid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Almacen#">
            <cfif url.SoloExistentes>
        	   and b.Eexistencia > 0
        	</cfif>
		</cfquery>
		<cfset LvarIACformato = rsSQL.Formato>

		<cfif rsSQL.Formato EQ "">
			<cfset fnmessage("No se encontró el '#url.IACcampo#' para el Articulo en el Almacen")>
		</cfif>

		<!--- 2. Obtiene el complemento del Socio --->
		<cfquery name="rsSQL" datasource="#url.conexion#">
			select cuentac
			from SNegocios
			where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNid#">
		</cfquery>
		<!--- 3.Aplica Máscara --->
		<cfset LvarFormato = "">
		<cfif len(trim(rsSQL.cuentac))>
			<cfset LvarFormato = CGAplicarMascara(LvarIACformato, rsSQL.cuentac)>
        <cfelse>
        	<cf_errorCode	code = "50809" msg = "Debe definir el Complemento Financiero para Compras/Ventas con Servicios, en el catálogo de Socios, tab Información Contable.">
		</cfif>
		<cfif Find('?',LvarFormato) GT 0>
			<cfset fnmessage("El complemento definido en Socio de Negocio '#rsSQL.cuentac#' no es suficiente para completar el #url.IACcampo#: #LvarIACformato#")>
		</cfif>
		<!--- 4. Genera Cuenta Financiera --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="false"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset fnmessage("#LvarERROR#")>
		</cfif>
		<!--- 5. Obtiene la Cuenta Asociada al Formato de Cuenta Financiera --->

		<cfquery name="rs" datasource="#url.conexion#">
			select a.Aid, a.Adescripcion, a.Acodigo, a.Ucodigo, b.Eexistencia, d.Cmayor, d.Ccuenta , d.Cformato, d.Cdescripcion, a.Icodigo, a.descalterna, a.Observacion
			from Articulos a

			inner join Existencias b
			on a.Ecodigo=b.Ecodigo
			and a.Aid=b.Aid
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

			inner join CFinanciera dd
				inner join CContables d
					on d.Ccuenta = dd.Ccuenta
			 on dd.Ecodigo=d.Ecodigo
			and dd.Cmayor='#mid(LvarFormato,1,4)#'
			and dd.CFformato='#LvarFormato#'

			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and b.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Almacen#">
			  and upper(rtrim(ltrim(a.Acodigo)))=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(url.dato))#">
			<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
				#preservesinglequotes(url.filtroextra)#
			</cfif>
            <cfif url.SoloExistentes>
        	   and b.Eexistencia > 0
        	</cfif>

			order by upper(a.Acodigo)
		</cfquery>
	<cfelseif isdefined("url.Almacen") and len(trim(url.Almacen))>
		<cfquery name="rs" datasource="#url.conexion#">
			select a.Aid, a.Adescripcion, a.Acodigo, a.Ucodigo, b.Eexistencia, d.Cmayor, d.Ccuenta , d.Cformato, d.Cdescripcion, a.Icodigo , a.descalterna, a.Observacion
			from Articulos a

			inner join Existencias b
			on a.Ecodigo=b.Ecodigo
			and a.Aid=b.Aid
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">

			inner join IAContables c
			on b.Ecodigo=c.Ecodigo
			and b.IACcodigo=c.IACcodigo
			and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">

			inner join CContables d
			on c.Ecodigo=d.Ecodigo
			and c.#url.IACcampo#=d.Ccuenta
			and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">

			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and b.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Almacen#">
			  and upper(rtrim(ltrim(a.Acodigo)))=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(url.dato))#">
			<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
				#preservesinglequotes(url.filtroextra)#
			</cfif>
            <cfif url.SoloExistentes>
        	   and b.Eexistencia > 0
        	</cfif>

			order by upper(a.Acodigo)
		</cfquery>
	<cfelse>
		<cfquery name="rs" datasource="#url.conexion#">
			select a.Aid, a.Acodigo, a.Adescripcion, a.Ucodigo, '' as Ccuenta, '' as Cmayor, '' as Cformato, '' as Cdescripcion, a.Icodigo, a.descalterna, a.Observacion
			from Articulos a
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			and upper(rtrim(ltrim(a.Acodigo)))=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(url.dato))#">
			<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
				#preservesinglequotes(url.filtroextra)#
			</cfif>

			order by upper(a.Acodigo)
		</cfquery>
	</cfif>

	<script language="JavaScript">
		function trim(dato) {
			dato = dato.replace(/^\s+|\s+$/g, '');
			return dato;
		}

		function obtener_formato(formato){
			if ( formato.length > 5){
				return formato.substring(5,formato.length);
			}
			return '';
		}

		<cfoutput>
		window.parent.document.#url.form#.#url.id#.value="#rs.Aid#";
		window.parent.document.#url.form#.#url.name#.value="#trim(rs.Acodigo)#";
		window.parent.document.#url.form#.#url.desc#.value="#JSStringFormat(rs.Adescripcion)#";
		window.parent.document.#url.form#.#url.descAlt#.value="#JSStringFormat(rs.descalterna)#";
		window.parent.document.#url.form#.#url.Observacion#.value="#JSStringFormat(rs.Observacion)#";
		window.parent.document.#url.form#.#url.ucodigo_oculto#.value="#rs.Ucodigo#";

		window.parent.document.#url.form#.Icodigo_#url.name#.value="#trim(rs.Icodigo)#";
		window.parent.document.#url.form#.cuenta_#url.name#.value="#trim(rs.Ccuenta)#";
		window.parent.document.#url.form#.cuentamayor_#url.name#.value="#trim(rs.Cmayor)#";
		//window.parent.document.#url.form#.cuentaformato_#url.name#.value="#trim(rs.Cformato)#";
		window.parent.document.#url.form#.cuentaformato_#url.name#.value=obtener_formato('#trim(rs.Cformato)#');

		window.parent.document.#url.form#.cuentadesc_#url.name#.value="#trim(rs.Cdescripcion)#";
		window.parent.document.#url.form#.Eexistencia_#url.name#.value="<cfif isdefined("rs.Eexistencia")>#trim(rs.Eexistencia)#</cfif>";

		if (window.parent.func#trim(Url.name)#) {window.parent.func#trim(Url.name)#();}
		</cfoutput>

	</script>
</cfif>

<cffunction access="private" name="CGAplicarMascara"  output="false" returntype="string">
	<cfargument name="formato" required="yes" type="string">
	<cfargument name="complemento" required="yes" type="string">
	<cfset contador = 0>
	<cfloop condition="#Find('?',formato)#">
		<cfset contador = contador + 1>
		<cfif len(Mid(complemento,contador,1))>
			<cfset formato = replace(formato,'?',Mid(complemento,contador,1))>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn formato>
</cffunction>

<cffunction access="private" name="fnmessage"  output="true" returntype="void">
	<cfargument name="msg" required="yes" type="string">
	<script language="JavaScript">
		<cfoutput>
		alert("#JSStringFormat(msg)#");
		window.parent.document.#url.form#.#url.id#.value="";
		//window.parent.document.#url.form#.#url.name#.value="";
		window.parent.document.#url.form#.#url.desc#.value="";
		window.parent.document.#url.form#.#url.descAlt#.value="";
		window.parent.document.#url.form#.#url.Observacion#.value="";
		window.parent.document.#url.form#.#url.ucodigo_oculto#.value="";

		window.parent.document.#url.form#.Icodigo_#url.name#.value="";
		window.parent.document.#url.form#.cuenta_#url.name#.value="";
		window.parent.document.#url.form#.cuentamayor_#url.name#.value="";
		//window.parent.document.#url.form#.cuentaformato_#url.name#.value="";
		window.parent.document.#url.form#.cuentaformato_#url.name#.value="";

		window.parent.document.#url.form#.cuentadesc_#url.name#.value="";

		if (window.parent.func#trim(Url.name)#) {window.parent.func#trim(Url.name)#();}
		</cfoutput>

	</script>
	<cfabort>
</cffunction>


