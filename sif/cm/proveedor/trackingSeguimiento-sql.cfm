<cfif isdefined("Form.ETidtracking") and Len(Trim(Form.ETidtracking))>
	<cfquery name="data" datasource="sifpublica">
		select CEcodigo, EcodigoASP, Ecodigo, cncache, ETfechasalida
		from ETracking
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">
	</cfquery>
</cfif>

<cfif isdefined("form.Alta")>
	<cfquery name="insDTracking" datasource="sifpublica">
		insert into DTracking(ETidtracking, CEcodigo, EcodigoASP, Ecodigo, cncache, DTactividad, DTubicacion, Observaciones, DTtipo, DTfecha, DTfechaincidencia, DTfechaest, CRid, DTnumreferencia, ETcodigo, DTrecibidopor, BMUsucodigo, CMATid, DTfechaactividad)
		values ( 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">, 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CEcodigo#">, 
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EcodigoASP#">,  
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#data.Ecodigo#">,  
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.cncache#">,
             <cfif isdefined('form.CMATid')>
             	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMATdescripcion#">,
             <cfelse>
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTactividad#">,
             </cfif>
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTubicacion#" null="#Len(Trim(Form.DTubicacion)) EQ 0#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#" null="#Len(Trim(Form.Observaciones)) EQ 0#">,
			 <cfqueryparam cfsqltype="cf_sql_char" value="#form.DTtipo#">, 
			 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			 <cfif Len(Trim(Form.DTfechaincidencia))>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaincidencia)#">,
			 <cfelse>
			 	null,
			 </cfif>
			 <cfif isdefined("Form.DTfechaest") and Len(Trim(Form.DTfechaest))>
			 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaest)#">,
			 <cfelse>
			 	null,
			 </cfif>
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#" null="#Form.CRid EQ -1#">, 
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTnumreferencia#" null="#Len(Trim(Form.DTnumreferencia)) EQ 0#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETcodigo#">, 
			 <cfif isdefined("Form.DTrecibidopor") and Len(Trim(Form.DTrecibidopor)) NEQ 0>
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTrecibidopor#" null="#Len(Trim(Form.DTrecibidopor)) EQ 0#">,
			 <cfelse>
				 null,
			 </cfif>
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
             <cfif isdefined('form.CMATid')>
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMATid#">, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaactividad)#">
           	 <cfelse>
             	null, null
             </cfif>
		)
	</cfquery>
	
	<cfquery name="countTracking" datasource="sifpublica">
		select count(1) as cantidad
		from DTracking
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">
	</cfquery>

	<!--- Actualiza campos en el Encabezado de Tracking --->
	<cfquery name="updEncabezado" datasource="sifpublica">
		update ETracking set 
			ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">,
			CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#" null="#Form.CRid EQ -1#">, 		
			<cfif isdefined("Form.DTrecibidopor") and Len(Trim(Form.DTrecibidopor)) NEQ 0>
			ETrecibidopor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTrecibidopor#" null="#Len(Trim(Form.DTrecibidopor)) EQ 0#">,
			</cfif>
			<cfif countTracking.cantidad EQ 1 and Len(Trim(data.ETfechasalida)) EQ 0>
			ETfechasalida = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaincidencia)#">,
			</cfif>
			<cfif isdefined("Form.DTtipo") and Form.DTtipo EQ 'T'>
			ETfechaentrega = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaincidencia)#">,
			</cfif>
			<cfif isdefined("Form.DTtipo") and (Form.DTtipo eq 'S' or Form.DTtipo eq 'E')>
			ETestado = 'T',
			</cfif>
            ETfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			ETnumreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTnumreferencia#" null="#Len(Trim(Form.DTnumreferencia)) EQ 0#">
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">
	</cfquery>

	<!--- Inserta en la tabla de Historicos de Cambios de Estados del Tracking --->
	<cfquery name="insHTracking" datasource="sifpublica">
		insert into HCEstadosTracking(ETidtracking, Ecodigo, ETcodigo)
		values ( 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#data.Ecodigo#">,  
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">
		)
	</cfquery>

<cfelseif isdefined("form.Cambio")>

	<cf_dbtimestamp datasource="sifpublica"
					table="DTracking"
					redirect="trackingSeguimiento.cfm"
					timestamp="#form.ts_rversion#"
					field1="DTidtracking" 
					type1="numeric" 
					value1="#form.DTidtracking#" >

	<cfquery name="updDTracking" datasource="sifpublica">
		update DTracking set 
			DTactividad = <cfif isdefined('form.CMATid')> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMATdescripcion#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTactividad#"></cfif>,
			DTubicacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTubicacion#" null="#Len(Trim(Form.DTubicacion)) EQ 0#">,
			Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#" null="#Len(Trim(Form.Observaciones)) EQ 0#">,
			DTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DTtipo#">, 
			<cfif Len(Trim(Form.DTfechaincidencia))>
				DTfechaincidencia = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaincidencia)#">,
			<cfelse>
				DTfechaincidencia = null,
			</cfif>
			<cfif isdefined("Form.DTfechaest") and Len(Trim(Form.DTfechaest))>
				DTfechaest = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaest)#">,
			<cfelse>
				DTfechaest = null,
			</cfif>
			CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#" null="#Form.CRid EQ -1#">, 
			DTnumreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTnumreferencia#" null="#Len(Trim(Form.DTnumreferencia)) EQ 0#">,
			ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETcodigo#">, 
			<cfif isdefined("Form.DTrecibidopor") and Len(Trim(Form.DTrecibidopor)) NEQ 0>
			DTrecibidopor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTrecibidopor#" null="#Len(Trim(Form.DTrecibidopor)) EQ 0#">,
			<cfelse>
			DTrecibidopor = null,
			</cfif>
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
            <cfif isdefined('form.CMATid')>
            CMATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMATid#">, 
            DTfechaactividad = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaactividad)#">
            <cfelse>
            CMATid = null,
            DTfechaactividad = null
            </cfif>
		where DTidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DTidtracking#">
	</cfquery>

	<!--- Actualiza campos en el Encabezado de Tracking --->	
	<cfquery name="updEncabezado" datasource="sifpublica">
		update ETracking set 
			ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">,
			CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#" null="#Form.CRid EQ -1#">, 
			<cfif isdefined("Form.DTrecibidopor") and Len(Trim(Form.DTrecibidopor)) NEQ 0>
			ETrecibidopor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTrecibidopor#" null="#Len(Trim(Form.DTrecibidopor)) EQ 0#">,
			</cfif>
			<cfif isdefined("Form.DTtipo") and Form.DTtipo EQ 'T'>
			ETfechaentrega = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DTfechaincidencia)#">,
			</cfif>
			<cfif isdefined("Form.DTtipo") and (Form.DTtipo eq 'S' or Form.DTtipo eq 'E')>
			ETestado = 'T',
			</cfif>
            ETfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			ETnumreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTnumreferencia#" null="#Len(Trim(Form.DTnumreferencia)) EQ 0#">
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">
	</cfquery>

<cfelseif isdefined("form.Baja")>

	<cfquery name="delDTracking" datasource="sifpublica">
		delete from DTracking 
		where DTidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DTidtracking#">
	</cfquery>
	
</cfif>

<cfoutput>
<form action="trackingSeguimiento.cfm" method="post" name="sql">
	<input type="hidden" name="ETidtracking" value="#Form.ETidtracking#">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
