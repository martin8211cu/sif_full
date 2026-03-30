<cf_htmlReportsHeaders 
	irA="Reporte_Requisiciones.cfm"
	FileName="Reporte_Requisiciones.xls"
	title="Reporte Requisiciones"
	download="no"
	preview="no"
	Back="no"
	close="yes"
	>

<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">


<cfquery datasource="#session.DSN#" name="rsForm">
	select  
		cf.CFdescripcion,
		al.Bdescripcion,
		dA.Pid as identificacionA, (dA.Papellido1 #_Cat# ' ' #_Cat# dA.Papellido2 #_Cat# ' ' #_Cat# dA.Pnombre) as NombreCompletoA,
		dR.Pid as identificacionR, (dR.Papellido1 #_Cat# ' ' #_Cat# dR.Papellido2 #_Cat# ' ' #_Cat# dR.Pnombre) as NombreCompletoR,
		a.ERFechaA,
	   a.ERidref,
		a.ERid, 
		a.ERdescripcion, 
		a.Aid, 
		rtrim(a.ERdocumento) as ERdocumento, 
		a.Ocodigo, 
		rtrim(upper(a.TRcodigo)) as TRcodigo, 
		a.ERFecha, 
		a.ERtotal, 
		a.ERusuario, 
		a.Dcodigo, 
		a.EcodigoRequi, 
		a.Ecodigo, 
		a.ERidref,
		b.DRlinea as LDRlinea,
		b.ERid as LERid, 
		b.Aid as LAid, 
		b.DRcantidad as LDRcantidad,
        b.DRcosto as LDRcosto, 
		c.Acodigo as LAcodigo,
        c.Acodalterno as LAcodigoAlterno, 
		c.Adescripcion as LAdescripcion,
		Ext.Eexistencia as Disponible,
        Ext.Eestante, 
        Ext.Ecasilla,
        Ext.Ecostou,
		a.Observaciones,
		u.Udescripcion,
		t.TRdescripcion
	from ERequisicion a
	inner join DRequisicion b
		on b.ERid = a.ERid
	left outer join CFuncional cf 
		on cf.CFid = b.CFid
		and cf.Ecodigo = a.Ecodigo
	left outer join TRequisicion t 
		on a.TRcodigo = t.TRcodigo	
		and t.Ecodigo = a.Ecodigo
	inner join Articulos c 
     	on c.Aid = b.Aid
		and a.Ecodigo = c.Ecodigo
	inner join Unidades u
        on c.Ucodigo = u.Ucodigo
		and a.Ecodigo = u.Ecodigo  
	left outer join Existencias Ext
    	on b.Aid= Ext.Aid   
		and a.Ecodigo = ext.Ecodigo
	inner join Almacen al
	    on al.Aid=a.Aid
		and a.Ecodigo = al.Ecodigo 
	left outer join Usuario uA
		on uA.Usucodigo = a.UsucodigoA
	left outer join DatosPersonales dA
		on uA.datos_personales = dA.datos_personales
	left outer join Usuario uR
		on uR.Usulogin = a.ERusuario
	left outer join DatosPersonales dR
		on uR.datos_personales = dR.datos_personales	
	where 
		a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERid#">
	and Ext.Alm_Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Alm_aid#">	
	order by c.Adescripcion
</cfquery>

<cfset contador = 1>
<cfset MaxLineasReporte = 16>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
<cfloop query="rsForm">
<cfoutput>
	<tr align="center">
		<td width="11%">&nbsp;</td>
	</tr>
	<cfif contador eq 1>
	
	<!---<tr align="center">
		<td>&nbsp;</td>
	</tr>--->
	<tr align="center">
		<td style="font-size:24px" class="tituloListas" colspan="7"><strong>Requisiciones de Inventario</strong></td>
	</tr>
	<tr>
		<td>&nbsp;
		</td>
	</tr>
	
	<tr align="center">
			<td>&nbsp;</td>
		</tr>

<cfif isdefined('url.Intercompany') and url.Intercompany>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
    	select Edescripcion from Empresas
        where Ecodigo =  #rsForm.Ecodigo#       
    </cfquery>
	<tr align="left">
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Empresa Origen:</strong>&nbsp; #rsEmpresa.Edescripcion#</td>
	</tr>
</cfif>		
	<tr align="left">
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Requisici&oacute;n Realizada por:</strong>&nbsp; #rsForm.NombreCompletoR#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Centro Funcional:</strong>&nbsp; #rsForm.CFdescripcion#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="7"class="tituloListas"><strong>Descripci&oacute;n de la Requisici&oacute;n:</strong> &nbsp; #rsForm.ERdescripcion#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="2" class="tituloListas"><strong>N° de Documento:</strong> &nbsp; #rsForm.ERdocumento#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="5" class="tituloListas"><strong>Tipo de Requisición:</strong> &nbsp; #rsForm.TRdescripcion#</td>
	</tr>
	<tr>
		<td style="font-size:14px"  colspan="7" class="tituloListas"><strong>Requisi&oacute;n de Devoluci&oacute;n:</strong> &nbsp;<cfif #rsForm.ERidref# neq ''>SI <cfelse> NO</cfif> </td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="2" class="tituloListas"><strong>Almac&eacute;n:</strong> &nbsp; #rsForm.Bdescripcion#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="2" class="tituloListas"><strong>Fecha de Solicitud:</strong> &nbsp; #DateFormat(rsForm.ERfecha, "DD-MM-YYYY")#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="7" class="tituloListas"><strong>Fecha de Aprobaci&oacute;n:</strong> &nbsp; #DateFormat(rsForm.ERfecha, "DD-MM-YYYY")#</td>
	</tr>
	<tr>
		<td style="font-size:14px" colspan="20" class="tituloListas"><strong>Observaciones:</strong> &nbsp; #rsForm.Observaciones#</td>
	</tr>
		<tr>
			<td class="tituloAlterno"></td>
		</tr>		
		<tr>
			<td style="font-size:20px" nowrap="nowrap" colspan="7" align="center"><strong>Detalle de Artículos</strong></td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="8" align="center"><hr /></td>
		</tr>			
		<tr nowrap="nowrap" align="center" class="tituloListas">
			<td align="left" nowrap="nowrap"><strong>Artículo Código</strong></td>
			<td colspan="3" align="left" nowrap="nowrap"><strong>    Descripción del Artículo</strong></td>
            <td align="right" nowrap="nowrap"><strong>Ubicacion</strong></td>
            <td align="right" nowrap="nowrap"><strong>Unidad Medida</strong></td>
			<td align="right" nowrap="nowrap"><strong>Cantidad</strong></td>
       <!---     <td align="right" nowrap="nowrap"><strong>Costo</strong></td>	--->
			<tr>
				<td>&nbsp;			
			</td>
		</tr>
</cfif>
</cfoutput>						
		
		<cfoutput>		
		
        <cfset LvarCosto= #rsForm.Ecostou#*#rsForm.LDRcantidad#>
		<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		  <td style="font-size:14px" align="left">#rsForm.LAcodigo#-#rsForm.LAcodigoAlterno#</td>
			<td colspan="3" style="font-size:14px" align="left" nowrap="nowrap">#rsForm.LAdescripcion#</td>
            <td style="font-size:14px" align="right"> #rsForm.Eestante#-#rsForm.Ecasilla#&nbsp;&nbsp;</td>
			<td style="font-size:14px" align="right">#rsForm.Udescripcion#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td style="font-size:14px" align="right">#rsForm.LDRcantidad#&nbsp;&nbsp;</td>
<!---            <td style="font-size:14px" align="right">#LSNumberFormat(LvarCosto,'9,9.99')#&nbsp;&nbsp;</td>--->
		</tr>
		<cfset contador = contador + 1>
		
		<cfif contador eq MaxLineasReporte>
			<tr>
				<td>
					<p style="page-break-before: always">		
					<cfset contador = 1>		
				</td>
			</tr>
			</cfif>		
			</tr>
	
		</cfoutput>
		</cfloop>
			

		<tr><td align="center" colspan="9">***Fin de Linea***</td></tr>
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<tr>
			<td nowrap="nowrap" colspan="7" align="center">&nbsp;</td>
		</tr>			
		<tr>
			<td nowrap="nowrap"  colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________</td>
			<td width="7%">&nbsp;</td>
			<td width="23%"  align="left" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________</td>

		</tr>
		<tr>
			<td nowrap="nowrap"  align="left" colspan="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Despachado por</strong></td>
			<td>&nbsp;</td>
			<td nowrap="nowrap"  align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recibido Conforme</strong></td>
		</tr>
</table>

