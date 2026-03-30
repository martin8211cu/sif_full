
<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_DatosAdjuntos = t.translate('LB_DatosAdjuntos','Datos Adjuntos','/rh/generales.xml')>
<cfset LB_Archivo = t.translate('LB_Archivo','Archivo','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')> 
<cfset LB_SubidoPor = t.translate('LB_SubidoPor','Subido Por','/rh/generales.xml')> 
<cfset LB_Aprobado = t.Translate('LB_Aprobado','Aprobado','/rh/generales.xml')>
<cfset LB_Aprobar = t.Translate('LB_Aprobar','Aprobar','/rh/generales.xml')>
<cfset LB_Eliminar = t.Translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_Descargar = t.Translate('LB_Descargar','Descargar','/rh/generales.xml')>
<cfset LB_Regresar = t.Translate('Regresar','Regresar','/rh/generales.xml')>
<cfset LB_EstaSeguroQueDeseaEliminarElArchivo = t.Translate('LB_EstaSeguroQueDeseaEliminarElArchivo','Está seguro que desea eliminar este archivo','/rh/generales.xml')>
<cfset MSG_DeseaAprobarElDatoAdjunto = t.Translate('MSG_DeseaAprobarElDatoAdjunto','Desea aprobar el Dato Adjunto?')>

<cfif isdefined ('url.DEid') and not isdefined ('form.DEid') and len(trim(url.DEid)) gt 0 >
	<cfset form.DEid = url.DEid >
</cfif>

<!--- Valida si el empleado a consultar se encuentra en tabla DatosOferentes --->
<cfquery name="rsValidaEmpleado" datasource="#session.dsn#">
	select RHOid
	from DatosOferentes 
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfif rsValidaEmpleado.recordcount and len(trim(rsValidaEmpleado.RHOid))>
	<cfset fk = 'RHOid'>
	<cfset fkvalor = rsValidaEmpleado.RHOid>

	<cfquery datasource="#Session.DSN#">
		update DatosOferentesArchivos set 
			DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaEmpleado.RHOid#">	
	</cfquery>
<cfelse>
	<cfset fk = 'DEid'>
	<cfset fkvalor = form.DEid>	
</cfif>

<cfset modoDatosAdjuntos = "ALTA">
<cfif isdefined("form.DOAid") and len(trim(form.DOAid))>
	<cfset modoDatosAdjuntos = "CAMBIO">
</cfif>

<cfif isdefined("fromAprobacionCV")> <!--- si se trabaja desde aprobacion de curriculum vitae --->
	<cfset self = "AprobacionCV.cfm?DEid=#form.DEid#&tab=7">
	<cfset destino = "AprobacionCV-sql.cfm" >	
<cfelse>
	<cfset self = "AprobacionCV.cfm">
	<cfset destino = "AprobacionCV-sql.cfm" >	
</cfif>


<cf_dbfunction name="op_concat" returnvariable="concat">

<cfif modoDatosAdjuntos neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">		
		select dof.DOAid, dof.DOAnombre as archivo, case when tipo = 'I' then 'Interno' else 'Externo' end as tipo,
		(	select de.DEnombre #concat# ' ' #concat# de.DEapellido1 #concat# ' ' #concat# de.DEapellido2
			from Usuario u
			inner join UsuarioReferencia ur
		        on ur.Usucodigo = u.Usucodigo
		        and ur.STabla = 'DatosEmpleado'
		        inner join DatosEmpleado de
		        	on de.DEid = convert(numeric,ur.llave)
			inner join DatosPersonales dp
		        on dp.datos_personales = u.datos_personales
		        and dp.Pid = de.DEidentificacion
		    where de.DEid = dof.DEid
	    ) as subidoPor,
	    aprobado
		from DatosOferentesArchivos dof
		where <cfoutput>#fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fkvalor#">
			and dof.DOAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOAid#">
	</cfquery> 
</cfif>

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr> 
	<tr>
		<td width="50%" valign="top">
			<cfquery name="rsLista" datasource="#session.DSN#"> 
				select DOAid, DOAnombre, #form.DEid# as DEid, 
				case when aprobado = 1 then 'X' else '' end as estado
				from DatosOferentesArchivos 
				where <cfoutput>#fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fkvalor#">
			</cfquery> 

			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="DOAnombre,estado"/>
				<cfinvokeargument name="etiquetas" value="#LB_DatosAdjuntos#,#LB_Aprobado#"/>
				<cfinvokeargument name="formatos" value="V,V,V,V"/>
				<cfinvokeargument name="align" value="left,center,center,center"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="DOAid"/>
				<cfinvokeargument name="irA" value="#self#"/>
				<cfinvokeargument name="formName" value="formDatosAdjuntosLista"/>
			</cfinvoke>
		</td>
		<td width="50%" valign="top">
			<cfoutput>
				<form name="formDatosAdjuntos" action="#destino#" method="post">
					<input type="hidden" name="fk" value="#fk#">
					<input type="hidden" name="fkvalor" value="#fkvalor#">
					<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
					<input type="hidden" name="DOAid" value="<cfif isdefined('data')>#data.DOAid#</cfif>">
					<cfif isdefined("fromAprobacionCV")> <!--- si se trabaja desde aprobacion de curriculum vitae --->
						<input type="hidden" name="tab" value="7">
					</cfif>

					<table width="100%" cellpadding="2" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="20%" align="right"><strong>#LB_Archivo#:&nbsp;</strong></td>
							<td width="32%"><cfif modoDatosAdjuntos neq 'ALTA'>#data.archivo#</cfif></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>#LB_Tipo#:&nbsp;</strong></td>
							<td><cfif modoDatosAdjuntos neq 'ALTA'>#data.tipo#</cfif></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>#LB_SubidoPor#:&nbsp;</strong></td>
							<td><cfif modoDatosAdjuntos neq 'ALTA'>#data.subidoPor#</cfif></td>
						</tr>
						<tr>
							<td colspan="4" align="center">
								<cfif modoDatosAdjuntos neq 'ALTA'>
	                                <cfif data.aprobado eq 1>
	                                	<input type="submit" onclick="return fnDescargar(#data.DOAid#);" class="btnGenerar" value="#LB_Descargar#">
	                                	<input type="submit" name="btnEliminar" onclick="return fnEliminar();" class="btnEliminar" value="#LB_Eliminar#">
										<input type="submit" onclick="fnRegresar();" class="btnAnterior" value="#LB_Regresar#">
	                                <cfelse>    
	                                	<input type="submit" onclick="return fnDescargar(#data.DOAid#);" class="btnGenerar" value="#LB_Descargar#">
										<input type="submit" name="btnAprobar" onclick="return fnAprobar();" class="btnAplicar" value="#LB_Aprobar#">
										<input type="submit" onclick="fnRegresar();" class="btnAnterior" value="#LB_Regresar#">
	                                </cfif>
								<cfelse>
									<cf_botones values="Regresar">
								</cfif>
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
				</form>
			</cfoutput>
		</td>
	</tr>
</table>

<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" ></iframe>


<script type="text/javascript">
	function fnRegresar(){
		document.formDatosAdjuntos.DOAid.value = '';
		document.formDatosAdjuntos.action = "AprobacionCV.cfm?DEid=<cfoutput>#form.DEid#</cfoutput>&tab=7";
	}
	
	function fnAprobar(){
		if (confirm('<cfoutput>#MSG_DeseaAprobarElDatoAdjunto#</cfoutput>'))
			return true;
		else
			return false;
	}

	function fnDescargar(llave){ 
		var frame = document.getElementById("FRAMECJNEGRA");
		<cfoutput>
        	frame.src = "/cfmx/commons/Tags/jupload.cfm?downloadFile=1&pkllave="+llave+"&pk=DOAid&tabla=DatosOferentesArchivos&nombre=DOAnombre&campo=DOAfile";   
      	</cfoutput> 

		return false;
    } 

	function fnEliminar(){
        if(confirm("<cfoutput>#LB_EstaSeguroQueDeseaEliminarElArchivo#</cfoutput>?"))
        	return true;
		else
			return false;
    } 
</script>			