<!---  					<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css"> --->
<cfoutput>
							<cfset maxCols = 3>
							<cfif cons1.recordCount GT 0>
							<!--- 	<cfif cons1.recordCount GT 0 > --->
							<cfset Prof = "">
						<!--- 	<cfset vMateria = "">
							<cfset vAlumno = ""> --->
						<cfquery name="rsDatos" dbtype="query">
							 select *
							 from cons1
							 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
							   <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  ---> 
						</cfquery>
					<!--- 	<cfif rsDatos.RecordCount gt 0> --->
								
      <table width="100%" cellspacing="0" >
        <!--- 	<cfloop query="cons1"> --->
        <!--- <cfif vMateria NEQ cons1.Mnombre> --->
        <!--- <cfset vMateria = Cons1.Mnombre> --->
        <!--- pintar aqui los datos de la Alumno --->
        <tr class="subTitulo"> 
          <td colspan="3" align="center"  nowrap  class="EncabListaCorte" style="border: 1px solid ##000000"><strong>Observaciones:&nbsp;</strong></td>
          <td colspan="6" align="center"  nowrap  class="EncabListaCorte"  style="border: 1px solid ##000000"><strong> 
            &nbsp; &nbsp; </strong><strong>Asistencia:&nbsp; &nbsp; &nbsp; </strong></td>
          <!--- <td  width="20%"align="left"  class="encabReporte"  nowrap ><strong>&nbsp; </strong></td> --->
        </tr>
        <tr > 
          <td width="9%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Reforzamiento</td>
          <td width="6%" align="center" valign="top" style="border: 1px solid ##000000">Llamada 
            de Atenci&oacute;n</td>
          <td width="11%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Advertencia</td>
          <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Ausencias</td>
          <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Llegada 
            Tard&iacute;a </td>
          <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Salida 
            Temprano </td>
        </tr>
        <tr class="subTitulo" <cfif  #rsDatos.RecordCount# NEQ 0 and  #rsDatos.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
          <td width="9%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
          <td width="6%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
          <td width="11%" align="center" nowrap style="border: 1px solid ##000000">&nbsp;</td>
          <td width="9%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
          <td width="8%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
          <td width="8%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
          <td width="10%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
          <td width="6%" align="center"  nowrap style="border: 1px solid ##000000">Just</td >
          <td  nowrap align="center" style="border: 1px solid ##000000">Injust</td>
        </tr>
        <!--- 	</cfif> --->
        <tr class="subTitulo" <cfif  rsDatos.RecordCount NEQ 0 and  rsDatos.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 

          <td width="9%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- <cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
            <cfquery name="rsObservacion" dbtype="query">
            select count(codigo) as R from cons1 where NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'O' and subtipo = 'P' </cfquery> <cfif rsObservacion.RecordCount NEQ 0>
              #rsObservacion.R# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="6%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- 	<cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
            <cfquery name="rsObservacion" dbtype="query">
            select count(codigo) as N from cons1 where NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'O' and subtipo = 'N' </cfquery> <cfif rsObservacion.RecordCount NEQ 0>
              #rsObservacion.N# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- 	<cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="11%" align="center" nowrap  style="border: 1px solid ##000000"> 
            <!--- 	<cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
            <cfquery name="rsObservacion" dbtype="query">
            select count(codigo) as A from cons1 where NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'O' and subtipo = 'A' </cfquery> <cfif rsObservacion.RecordCount NEQ 0>
              #rsObservacion.A# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="9%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- 	<cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- <cfif #cons1.justificado# EQ 'S'> --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as AJ from cons1 where justificado = 'S' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'A' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.AJ# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- 	<cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="8%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- <cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- <cfif len(trim(#cons1.justificado#)) EQ 0> --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as AIJ from cons1 where justificado = 'N' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'A' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.AIJ# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- 	<cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="8%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- <cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as TJ from cons1 where justificado = 'S' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'T' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.TJ# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="10%" nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- <cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as TIJ from cons1 where justificado = 'N' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'T' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.TIJ# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td>
          <td width="6%" align="center"  nowrap  style="border: 1px solid ##000000"> 
            <!--- 	<cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as RT from cons1 where justificado = 'S' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'R' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.RT# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td >
          <td  nowrap align="center"  style="border: 1px solid ##000000"> 
            <!--- <cfif len(trim(#cons1.codigo#)) NEQ 0 > --->
            <!--- <cfif len(trim(#cons1.justificado#)) EQ 0> --->
            <cfquery name="rsAsistencia" dbtype="query">
            select count(codigo) as RTIJ from cons1 where justificado = 'N' and 
            NombreAl = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
            <!--- and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  --->
            and tipo = 'A' and subtipo = 'R' </cfquery> <cfif rsAsistencia.RecordCount NEQ 0>
              #rsAsistencia.RTIJ# 
              <cfelse>
              &nbsp; </cfif> 
            <!--- </cfif> --->
            <!--- <cfelse>
														&nbsp;
													</cfif>  --->
          </td>
        </tr>
        <cfif len(trim(rsDatos.codigo)) NEQ 0 and rsDatos.NombreAl eq #vAlumno# >
          <cfloop query="rsDatos">
            <tr class="subTitulo" <cfif  rsDatos.RecordCount NEQ 0 and  rsDatos.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
              <td align="center" width="9%"  style="border: 1px solid ##000000"> 
                #LSdateFormat(rsDatos.fecha,'dd/MM/YYYY')# </td>
              <td width="70%" colspan="8"  style="border: 1px solid ##000000"> 
                #rsDatos.descripcion# </td>
            </tr>
          </cfloop>
          <cfelse>
          <tr class="subTitulo" <cfif  rsDatos.RecordCount NEQ 0 and  rsDatos.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
            <td align="center" width="9%"  style="border: 1px solid ##000000">&nbsp; 
            </td>
            <td width="70%" colspan="8"  style="border: 1px solid ##000000">&nbsp; </td>
          </tr>
        </cfif>
        <!--- </cfloop> --->
      </table>
							
									<table width="100%"  cellspacing="0">
										<tr> 
											<td colspan="4">&nbsp;</td>
										</tr>
									</table>
								<!--- </cfif> --->
							<cfelse>
								<!--- <table width="100%" border="1" cellspacing="0">  --->			
									<!--- <tr> 
										
								<td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El Alumno no tiene Incidencias definidos para este periodo</td>
									</tr>
									<tr> 
										<td colspan="4" align="center"> ------------------ 1 - No existen 
										Incidencias, para la este alumno ------------------ </td>
									</tr>
									<tr> 
										<td colspan="4">&nbsp;</td>
									</tr> --->
									  <table width="100%" cellspacing="0" >
											<tr class="subTitulo"> <!--- encabReporte --->
											  <td colspan="3" align="center"  nowrap  class="EncabListaCorte" style="border: 1px solid ##000000"><strong>Observaciones:&nbsp;</strong></td>
											  <td colspan="6" align="center"  nowrap  class="EncabListaCorte"  style="border: 1px solid ##000000"><strong> 
												&nbsp; &nbsp; </strong><strong>Asistencia:&nbsp; &nbsp; &nbsp; </strong></td>
											  <!--- <td  width="20%"align="left"  class="encabReporte"  nowrap ><strong>&nbsp; </strong></td> --->
											</tr>
											<tr > 
											  <td width="9%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Reforzamiento</td>
											  <td width="6%" align="center" valign="top" style="border: 1px solid ##000000">Llamada 
												de Atenci&oacute;n</td>
											  <td width="11%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Advertencia</td>
											  <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Ausencias</td>
											  <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Llegada 
												Tard&iacute;a </td>
											  <td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Salida 
												Temprano </td>
											</tr>
											<tr class="subTitulo" > 
											  <td width="9%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="6%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="11%" align="center" nowrap style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="9%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
											  <td width="8%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
											  <td width="8%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
											  <td width="10%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
											  <td width="6%" align="center"  nowrap style="border: 1px solid ##000000">Just</td >
											  <td  nowrap align="center" style="border: 1px solid ##000000">Injust</td>
											</tr>
											<tr class="subTitulo" > 
											  <td width="9%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="6%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="11%" align="center" nowrap style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="9%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="8%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="8%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="10%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											  <td width="6%" align="center"  nowrap style="border: 1px solid ##000000">&nbsp;</td >
											  <td  nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
											</tr>
								</table>
							</cfif>
				<!--- </cfif> --->	
				
</cfoutput>