<html>
<head>
<title>Salidas del Almac&eacute;n de la Estaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
.style2 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</head>
<body>

<cfoutput>
	<cfif isdefined("url.EMAid") and not isdefined('form.EMAid')>
		<cfset form.EMAid = url.EMAid>
	</cfif>		
	<cfif isdefined("url.DMAid") and not isdefined('form.DMAid')>
		<cfset form.DMAid = url.DMAid>
	</cfif>		
	
	<cfset modo = "ALTA">
	
	<cfset nombreProd = "">	
	<cfset listaCods = "">	
	<cfset LvarListaNon = -1>
	
	<cfquery name="rsTurnos" datasource="#session.DSN#">
		select a.Turno_id
			, coalesce(dalm.DMAinvIni,0) as DMAinvIni
			, coalesce(dalm.DMAcompra,0) as DMAcompra
			, coalesce(dalm.DMAinvFin,0) as DMAinvFin	
			, o.Ocodigo
			, Codigo_turno
			, b.Tdescripcion		
			, coalesce(ap.ALMPcantidad,0) as ALMPcantidad
			, dalm.Aid as AlmacenOri
			, ap.Aid
			, dalm.Aid as idAlmacenOri
			, m.Bdescripcion
			, ar.Acodigo
			, ar.Adescripcion
			, ap.ALMPid
			, dalm.Art_Aid	
			, ap.ALMPdoc
			, alm.EMAestado
		from Turnoxofi a
			inner join Turnos b
				on b.Ecodigo=a.Ecodigo
					and b.Turno_id=a.Turno_id
		
			inner join Oficinas o
				on o.Ecodigo=b.Ecodigo
					and o.Ocodigo=a.Ocodigo
		
			inner join EMAlmacen alm
				on alm.Ecodigo=o.Ecodigo
					and alm.Ocodigo=o.Ocodigo
		
		
			inner join DMAlmacen dalm
				on dalm.Ecodigo=alm.Ecodigo	
					and dalm.EMAid=alm.EMAid
					and dalm.DMAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DMAid#">
					
			inner join Articulos ar
				on ar.Ecodigo=dalm.Ecodigo
					and ar.Aid=dalm.Art_Aid					
		
			left outer join ALMPistas ap
				on ap.Ecodigo=dalm.Ecodigo
					and ap.DMAid=dalm.DMAid
					and ap.Turno_id=b.Turno_id
		
			inner join Almacen m
				on m.Ecodigo=dalm.Ecodigo
					and m.Aid=dalm.Aid
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Testado=1
	</cfquery>			
	
	<cfset totSalidasAPista = 0>
	<cfif isdefined('rsTurnos') and rsTurnos.recordCount GT 0>
		<cfquery name="rsArticulo" dbtype="query">
			Select distinct Acodigo, Adescripcion, Art_Aid	
			from rsTurnos
		</cfquery>

		<cfif isdefined('form.EMAid') and form.EMAid NEQ ''>
			<cfquery name="rsDocsTurnos" datasource="#session.DSN#">
				Select distinct Turno_id,ALMPdoc
				from ALMPistas a
					inner join DMAlmacen b
						on b.Ecodigo=a.Ecodigo
							and b.DMAid=a.DMAid
				
					inner join EMAlmacen c
						on c.Ecodigo=b.Ecodigo
							and c.EMAid=b.EMAid
							and c.EMAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
				
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfif>
		
		<cfquery name="rsSumaCant" dbtype="query">
			Select 
				sum(ALMPcantidad) as cantidad
				, DMAinvIni
				, DMAcompra
				, DMAinvFin
				, Ocodigo
			from rsTurnos
			group by DMAinvIni,DMAcompra,DMAinvFin,Ocodigo
		</cfquery>		
		
		<cfset nombreProd = '(' & rsArticulo.Acodigo & ') ' & rsArticulo.Adescripcion>
		<cfset idArticulo = rsArticulo.Art_Aid>
		
		<cfset listaCods = ValueList(rsTurnos.Turno_id)>		
		<cfset totUnidIni = 0>
		<cfset totUnidFin = 0>
		
		<cfif isdefined('rsSumaCant') and rsSumaCant.recordCount GT 0>
			<cfset totUnidIni = rsSumaCant.DMAinvIni + rsSumaCant.DMAcompra>
			<cfset totSalidasAPista = rsSumaCant.cantidad>
			<cfset totUnidFin = totUnidIni - rsSumaCant.DMAinvFin>
			
			<cfquery name="rsAlmacenesPistas" datasource="#session.DSN#">
				Select distinct Alm_Aid
						, a.Bdescripcion
				from Pistas p
					inner join Oficinas o
						on o.Ecodigo=p.Ecodigo
							and o.Ocodigo=p.Ocodigo
				
					inner join Artxpista ap
						on ap.Ecodigo=o.Ecodigo
							and ap.Pista_id=p.Pista_id
				
					inner join Almacen a
						on a.Ecodigo=ap.Ecodigo
							and a.Aid=ap.Alm_Aid
							and a.Ocodigo=o.Ocodigo
							and a.Aid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTurnos.idAlmacenOri#">)
				
				where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and p.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSumaCant.Ocodigo#">	
					and p.Pestado=1
			</cfquery>			
		</cfif>
		
		<cfquery name="rsEstado" dbtype="query" maxrows="1">
			Select EMAestado
			from rsTurnos
		</cfquery>		
	</cfif>

	<cfif isdefined('form.btnGuardar')>
		<!--- Actualizando e insertando los datos de las salidas del almacen principal al de las pistas por turno --->
		<cfif isdefined("rsTurnos") and rsTurnos.recordCount GT 0>
			<cfloop query="rsTurnos">
				<cfset valor = evaluate("form.cant_#rsTurnos.Turno_id#")>				
				<cfset valorDoc = evaluate("form.docRef_#rsTurnos.Turno_id#")>								
				<cfif rsTurnos.ALMPid NEQ ''>
					<cfquery datasource="#session.DSN#">
						update ALMPistas set
							ALMPcantidad=<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">
							, ALMPdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valorDoc#">
						where ALMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTurnos.ALMPid#">
					</cfquery>							
				<cfelse>
					<cfif valor GT 0>
						<cfquery datasource="#session.DSN#"> 				
							insert into ALMPistas 
								(Ecodigo, DMAid, Art_Aid, Turno_id, Aid, ALMPcantidad, ALMPdoc, BMUsucodigo, BMfechaalta)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DMAid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idArticulo#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTurnos.Turno_id#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
								, <cfqueryparam cfsqltype="cf_sql_float" value="#valor#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#valorDoc#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								, <cf_dbfunction name="now">)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>			
		</cfif>
	</cfif>	
	
	<script language="javascript" type="text/javascript">
		function validaSalida(f){
			var ret = true;
			var ret2 = true;			
			<cfif listaCods NEQ ''>
				var objts = "<cfoutput>#listaCods#</cfoutput>";
				var arrObjts = objts.split(",");
				var sumaObjst = 0;
				var valorObjst = 0;			
				var valorDocRef = 0;								
				
				for (var i=0; i < arrObjts.length; i++){
					if(arrObjts[i] != ''){
						eval("f.cant_" + arrObjts[i] + ".value=qf(f.cant_" + arrObjts[i] + ")");				
						valorObjst = eval("new Number(f.cant_" + arrObjts[i] + ".value)");
						valorDocRef = eval("f.docRef_" + arrObjts[i] + ".value");						
						sumaObjst += eval("new Number(f.cant_" + arrObjts[i] + ".value)");
						if((valorObjst != '' && valorObjst > 0) && valorDocRef == ''){
							ret2 = false;
						}
					}
				}				
					
				var totSalida = new Number(f.totSalida.value);
				var totSalApista = new Number(sumaObjst);	
				if((totSalida > totSalApista) || (totSalida < totSalApista)){
					alert("  Error, el total de salidas en turnos (" + totSalApista + ")\nes distinto al total de unidades trasladadas a pista (" + totSalida + ")");
					ret = false;
				}
				if(!ret2){
					alert("  Error, existe una salida sin documento de referencia");
					ret = false;			
				}
				
			</cfif>
			if(f.Aid.value == ''){
				alert('Error, El Almacen Destino es Requerido');
				f.Aid.focus();
				ret = false;
			}	
			formatea();
			return ret;
		}
		function cerrar(){
			window.close();
		}	
		function calcTotal(){
			var sumaObjst = 0;
			var totSalVend = 0;				
			var objts = "<cfoutput>#listaCods#</cfoutput>";
			
			if (objts != ''){
				var arrObjts = objts.split(",");
				
				for (var i=0; i < arrObjts.length; i++){
					if(arrObjts[i] != ''){
						sumaObjst += eval("new Number(document.frame_Vend.cant_" + arrObjts[i] + ".value)");
					}
				}
				totSalVend = new Number(sumaObjst);			
			}
				
			document.frame_Vend.total.value = fm(totSalVend,2);;
		}
		function formatea(){
			var objts = "<cfoutput>#listaCods#</cfoutput>";
			
			if (objts != ''){
				var arrObjts = objts.split(",");
				
				for (var i=0; i < arrObjts.length; i++){
					if(arrObjts[i] != ''){
						eval("document.frame_Vend.cant_" + arrObjts[i] + ".value=qf(document.frame_Vend.cant_" + arrObjts[i] + ")");
					}
				}	
			}	
		}
		
		<cfif isdefined('form.btnGuardar')>	
			cerrar();	
		</cfif>			
	</script>	
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
	<form style="margin:0;" name="frame_Vend" method="post" action="salidas.cfm" onSubmit="javascript: return validaSalida(this);">
		<input type="hidden" name="DMAid" value="<cfif isdefined('form.DMAid') and form.DMAid NEQ ''>#form.DMAid#</cfif>">			
 		<input type="hidden" name="totSalida" value="#totUnidFin#">
		<input type="hidden" name="listaCods" value="<cfif isdefined('listaCods') and listaCods NEQ ''>#listaCods#</cfif>">
		
	  <table width="100%" cellpadding="0" cellspacing="0" border="0">  
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>		
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>		
        <tr>
          <td colspan="7" align="center"><span class="style1">Unidades  Despachadas hacia el Almacen de las Pistas </span></td>
        </tr>	
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>		
        <tr>
          <td colspan="7" align="center"><span class="style2">#nombreProd#</span> </td>
        </tr>
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>		
        <tr>
          <td colspan="7">&nbsp;&nbsp;<strong>Almac&eacute;n Destino:</strong>&nbsp;&nbsp;
			  <select name="Aid">
				<cfif isdefined('rsAlmacenesPistas') and rsAlmacenesPistas.recordCount GT 0>
					<cfloop query="rsAlmacenesPistas">
 						<option value="#rsAlmacenesPistas.Alm_Aid#">#rsAlmacenesPistas.Bdescripcion#</option>
					</cfloop>
				</cfif>
			  </select>		  </td>
        </tr>			
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>			
        <tr>
          <td colspan="7" align="center"><hr></td>
        </tr>				  
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>		
        <tr class="areaFiltro">
          <td width="6%" align="center">&nbsp;</td>
          <td width="38%" nowrap="nowrap"><strong>Nombre del Turno </strong></td>
          <td width="15%">&nbsp;</td>
          <td width="20%" align="right" nowrap="nowrap"><strong>Unidades Despachadas </strong></td>
          <td width="2%" align="center" nowrap="nowrap">&nbsp;</td>
          <td width="13%" align="center" nowrap="nowrap"><strong>Doc de Referencia</strong> </td>
          <td width="6%" align="center" nowrap="nowrap">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="7" align="center">&nbsp;</td>
        </tr>			
		<cfif isdefined('rsTurnos') and rsTurnos.recordCount GT 0>
			<cfloop query="rsTurnos">
				<cfset LvarListaNon = (CurrentRow MOD 2)>	
				
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="this.className='listaParSel';" onMouseOut="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				  <td align="right">&nbsp;</td>
				  <td>#Codigo_turno#&nbsp;-&nbsp;#Tdescripcion#</td>
				  <td>&nbsp;</td>
				  <td align="right">					  
				  		<input 
							type="text" 
							tabindex="-1"
							name="cant_#Turno_id#" 
							size="10" 
							maxlength="10" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcTotal();}"
							value="<cfif rsTurnos.ALMPcantidad NEQ ''>#LSCurrencyFormat(ALMPcantidad, 'none')#</cfif>">					</td>
				  <td align="center">&nbsp;</td>
				  <td align="center">
				  
					  <cfif isdefined('rsDocsTurnos') and rsDocsTurnos.recordCount GT 0>
							<cfquery name="rsDocsTurnosDet" dbtype="query">
								Select distinct ALMPdoc,Turno_id				  
								from rsDocsTurnos
								where Turno_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTurnos.Turno_id#">
							</cfquery>
					  </cfif>
		
				  		<input 
							type="text" 
							tabindex="-1"
							name="docRef_#Turno_id#" 
							<cfif rsTurnos.ALMPdoc NEQ '' or isdefined('rsDocsTurnosDet') and rsDocsTurnosDet.recordCount GT 0>
								readonly="true"							
							</cfif>
							size="10" 
							maxlength="25" 
							style="text-align: right;" 
							onFocus="javascript: this.select();"  
							value="<cfif rsTurnos.ALMPdoc NEQ ''>#ALMPdoc#<cfelseif isdefined('rsDocsTurnosDet') and rsDocsTurnosDet.recordCount GT 0>#rsDocsTurnosDet.ALMPdoc#</cfif>">				  
				  </td>
				  <td align="center">&nbsp;</td>
			    </tr>
			</cfloop>
		</cfif>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>		
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td align="right"><strong>Total</strong></td>
          <td align="right"><strong>
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true" tabindex="-1"
				name="total" 
				size="20" 
				maxlength="20" 
				style="text-align: right;" 
				onBlur="javascript:fm(this,2);"  
				onFocus="javascript:this.value=qf(this); this.select();"  
				onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
				value="">		  
		  </strong></td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>		
		
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>		
        <tr>
          <td colspan="7" align="center">

			<cfif isdefined('rsEstado') and rsEstado.recordCount GT 0 and rsEstado.EMAestado EQ 0>
				<input type="submit" name="btnGuardar" value="Guardar y Cerrar">
			<cfelse>
				<input type="button" onClick="javascript: cerrar();" name="Cerrar" value="Cerrar">
			</cfif>
		  </td>
        </tr>		
      </table>
	</form>	
</cfoutput>

<script language="javascript" type="text/javascript">
	calcTotal();
</script>

</body>
</html>
