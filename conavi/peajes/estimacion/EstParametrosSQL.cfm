<cfsetting requesttimeout="3600">
<cfif isdefined('form.CAMBIO')>
<cfset LvarPeriodo =  #form.Periodo# >
<cfset LvarPeaje   =  #form.Peaje# >

<cfset LvarEstado = 1 >
<cfset dia= 01>
<cfset arrPvid = ListToArray(#form.Pvid#)/>
<cfset arrPorc = ListToArray(#form.Porc#)/>
<cfset arrPerInicial = ListToArray(#form.PerInicial#)/>
<cfset arrMesInicial= ListToArray(#form.MesInicial#)/>
<cfset arrPerFinal = ListToArray(#form.PerFinal#)/>
<cfset arrMesFinal = ListToArray(#form.MesFinal#)/>

<cfloop index="x" from="1" to="#arrayLen(arrPvid)#"> 
 <cfset fechaInicial = #arrPerInicial[x]# * 100 + #arrMesInicial[x]#>
 <cfset fechaFinal = #arrPerFinal[x]# * 100 + #arrMesFinal[x]# > 
 <cfif #fechaInicial# GT #fechaFinal#>
     <cfset mensaje = "La fecha inicial no puede ser mayor">
	 <cfoutput>
	 <script language="javascript1.2" type="text/javascript">
	  <cfif mensaje neq "">
		alert("#mensaje#");
		history.back(-1);
		</cfif>
	</script>
	</cfoutput>
	<cf_dump var=" ">
 </cfif>
</cfloop>

<cfquery  datasource="#session.dsn#">
     Delete from COEstimacionIng 
	 where COEPeriodo = <cfqueryparam value="#LvarPeriodo#" cfsqltype="cf_sql_numeric"> and
	 Pid = <cfqueryparam value="#LvarPeaje#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfloop index="x" from="1" to="#arrayLen(arrPvid)#">
<cfquery datasource="#session.dsn#">
			insert into COEstimacionIng (
				COEPeriodo,
                Pid,
                PVid,
                Ecodigo, 
                COEPorcVariacion,
                COEPerInicial,
                COEMesInicial,
                COEPerFinal,
                COEMesFinal,
                COEFecha,
                COEEstado,
                COEFechaFormulacion, 
                COEUsuarioFormulacion,
                BMUsucodigo                    
			 )
   			values(
			     #LvarPeriodo#,
				 #LvarPeaje#,
				<cfoutput>#arrPvid[x]#</cfoutput>,
				#session.Ecodigo#,
				<cfoutput>#arrPorc[x]#</cfoutput>,
				<cfoutput>#arrPerInicial[x]#</cfoutput>,
                <cfoutput>#arrMesInicial[x]#</cfoutput>,
				<cfoutput>#arrPerFinal[x]#</cfoutput>,
				<cfoutput>#arrMesFinal[x]#</cfoutput>,
	            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(now(),"yyyy-mm-dd hh:mm:ss")#">,
				<cfoutput>'#LvarEstado#'</cfoutput>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="" null="yes">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				#session.usucodigo# 	
			)
		</cfquery>
</cfloop>
	<cfoutput>
		<script language="javascript" type="text/javascript">
		window.parent.location='EstParametrosForm.cfm?Periodo=#LvarPeriodo#&Peaje=#LvarPeaje#';
		</script>
    </cfoutput>
<cfelseif isdefined('form.ALTA')>

	<cfset LvarPeriodo = #form.Periodo#>
	<cfset LvarPeaje   = #form.Peaje#>
	<cfset LvarEstado = 1 >

	<cfquery name="rsRegistros" datasource="#session.dsn#">
		 Select count(COEid) as NumeroRegistros from COEstimacionIng 
		 where COEPeriodo = <cf_jdbcquery_param value="#LvarPeriodo#" cfsqltype="cf_sql_numeric"> and
		 Pid = <cf_jdbcquery_param value="#LvarPeaje#" cfsqltype="cf_sql_numeric">
	</cfquery>
		
	<cfif #rsRegistros.NumeroRegistros# GT 0>   
		<cfoutput>
			 <script language="javascript1.2" type="text/javascript">	 
				alert("Ya existen parámetros definidos para este peaje y para el periodo elegido");
				history.back(-1);
			 </script>		 
		</cfoutput>	
	<cfelse>

		<cfset arrPvid = ListToArray(#form.Pvid#)/>
		<cfset arrPorc = ListToArray(#form.Porc#)/>
		<cfset arrPerInicial = ListToArray(#form.PerInicial#)/>
		<cfset arrMesInicial= ListToArray(#form.MesInicial#)/>
		<cfset arrPerFinal = ListToArray(#form.PerFinal#)/>
		<cfset arrMesFinal = ListToArray(#form.MesFinal#)/>
	
	
		<cfloop index="x" from="1" to="#arrayLen(arrPvid)#"> 
		 <cfset fechaInicial = #arrPerInicial[x]# * 100 + #arrMesInicial[x]#>
		 <cfset fechaFinal = #arrPerFinal[x]# * 100 + #arrMesFinal[x]# > 
		 <cfif #fechaInicial# GT #fechaFinal#>
			 <cfset mensaje = "La fecha inicial no puede ser mayor">
			 <cfoutput>
				 <script language="javascript1.2" type="text/javascript">
				  <cfif mensaje neq "">
				     alert("#mensaje#");
					 history.back(-1);
				  </cfif>
				</script>
			</cfoutput>
			<cf_dump var=" ">
		 </cfif>
		</cfloop>
		<cfloop index="x" from="1" to="#arrayLen(arrPvid)#">		
		<cfquery datasource="#session.dsn#" name="rsParametros">
					insert into COEstimacionIng (
						COEPeriodo,
						Pid,
						PVid,
						Ecodigo, 
						COEPorcVariacion,
						COEPerInicial,
						COEMesInicial,
						COEPerFinal,
						COEMesFinal,
						COEFecha,
						COEEstado,
    					COEFechaFormulacion, 
                        COEUsuarioFormulacion,
						BMUsucodigo                    
					 )
					values(
						 #LvarPeriodo#,
						 #LvarPeaje#,
						<cfoutput>#arrPvid[x]#</cfoutput>,
						#session.Ecodigo#,
						<cfoutput>#arrPorc[x]#</cfoutput>,
						<cfoutput>#arrPerInicial[x]#</cfoutput>,
						<cfoutput>#arrMesInicial[x]#</cfoutput>,
						<cfoutput>#arrPerFinal[x]#</cfoutput>,
						<cfoutput>#arrMesFinal[x]#</cfoutput>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(now(),"yyyy-mm-dd hh:mm:ss")#">,
						<cfoutput>'#LvarEstado#'</cfoutput>,
					    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(now(),"yyyy-mm-dd hh:mm:ss")#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">,
						#session.Usucodigo# 	
					)					
		          </cfquery>	
		  </cfloop>
		<cfoutput>
	
			<script language="javascript" type="text/javascript">
			window.parent.location='EstParametrosForm.cfm?Periodo=#LvarPeriodo#&Peaje=#LvarPeaje#';
			</script>
		</cfoutput>
	</cfif>
<cfelse>
		<cfoutput>
			<script language="javascript" type="text/javascript">
			window.parent.location='EstParametros.cfm';
			</script>
		</cfoutput>
</cfif>



