
<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_Archivo = t.translate('LB_Archivo','Archivo','/rh/generales.xml')>
<cfset LB_ElColaboradorNoTieneDatosAdjuntosRegistrados = t.translate('LB_ElColaboradorNoTieneDatosAdjuntosRegistrados','El colaborador no tiene datos adjuntos registrados')>
<cfset MSG_PendienteDeAprobacionRH = t.translate('MSG_PendienteDeAprobacionRH','Pendiente de aprobación por RH','/rh/generales.xml')>

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
<cfelse>
	<cfset fk = 'DEid'>
	<cfset fkvalor = form.DEid>	
</cfif>

<cfset lvCols = 2>
<cfif isdefined ('LvarCPI') > 
	<cfset lvCols = 3>
</cfif>	

<cfset filtro = ""> 
<cfset lvAprobado = ''>

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2727" default="0" returnvariable="LvarAprobarDatosAdjuntos"/>

<cfif isdefined ('LvarAuto') and LvarAuto eq 1 > <!--- Si esta dentro de Autogestion --->
	<cfquery name="rsUsuario" datasource="#Session.DSN#">
		select u.Usucodigo
		from Usuario u
		inner join UsuarioReferencia ur
		   	on ur.Usucodigo = u.Usucodigo
		   	and ur.STabla = 'DatosEmpleado'
		   	inner join DatosEmpleado de
		    	on de.DEid = convert(numeric,ur.llave)
		inner join DatosPersonales dp
		   	on dp.datos_personales = u.datos_personales
		   	and dp.Pid = de.DEidentificacion    
		where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
	</cfquery>

	<cfset lvUsucodigo = rsUsuario.Usucodigo>

	<!--- Indica que archivos subidos requieren aprobacion para ser vistos en el curriculum vitae y en curriculum externo --->
	<cfif LvarAprobarDatosAdjuntos> 
		<!--- Valida si no se esta consultando desde Curriculum Vitae del Personal Interno --->
		<cfif not isdefined ('LvarCPI') > 
			<cfset lvAprobado = 'and aprobado = 1'>
		</cfif>

		<!--- Filtro mostrar archivos subidos a un funcionario por el mismo o por personal RH en Curriculum tomando en cuenta las condiciones que deben cumplirse para los archivos que requieran aprobacion ---> 
		<cfset filtro &= "(tipo = 'E' or (tipo = 'I' #lvAprobado# and UsuCreador != #lvUsucodigo#) or (tipo = 'I' and UsuCreador = #lvUsucodigo#))"> 
	</cfif>
</cfif>		

<cfquery name="rsDatosAdjuntos" datasource="#Session.DSN#">
	select DOAid, DOAnombre, aprobado
	from DatosOferentesArchivos 
	where <cfoutput>#fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fkvalor#">	 
	<cfif len(trim(filtro))>
    	and <cfoutput>#evaluate("filtro")#</cfoutput>
    </cfif>
</cfquery>	


<cf_dbfunction name="op_concat" returnvariable="concat">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<cfoutput><td colspan="#lvCols#" class="tituloListas">#LB_Archivo#</td></cfoutput>
	</tr>

	<cfif rsDatosAdjuntos.recordcount gt 0>
		<cfoutput query="rsDatosAdjuntos">
			<tr class="<cfif rsDatosAdjuntos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td>#DOAnombre#</td>
				<cfif isdefined ('LvarCPI') > 
					<td>
						<i style="cursor: pointer;" class="fa fa-download fa-lg" onclick="fnDescargar(#DOAid#)"></i>
					</td>
				</cfif>	
				<cfif aprobado neq 1 and LvarAprobarDatosAdjuntos> <!--- Mensaje Pendiente de aprobacion por RH --->
                	<td>
                		<cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="6#currentrow#" msg="#MSG_PendienteDeAprobacionRH#">
                	</td>
                <cfelse>
                	<td>&nbsp;</td>	
                </cfif>
            </tr>
        </cfoutput>
    <cfelse>
		<tr>
			<cfoutput><td colspan="#lvCols#" align="center">-#LB_ElColaboradorNoTieneDatosAdjuntosRegistrados#-</td></cfoutput>
		</tr>
	</cfif>
</table>            

<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" ></iframe>

<script type="text/javascript">
	function fnDescargar(llave){ 
		var frame = document.getElementById("FRAMECJNEGRA");
		<cfoutput>
        	frame.src = "/cfmx/commons/Tags/jupload.cfm?downloadFile=1&pkllave="+llave+"&pk=DOAid&tabla=DatosOferentesArchivos&nombre=DOAnombre&campo=DOAfile";   
      	</cfoutput> 
    } 
</script>