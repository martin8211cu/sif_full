<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("Form.Cambio")  or ( isdefined("form.FACCid") and len(trim(form.FACCid)) gt 0 )>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

	<cfquery name="rsCajas" datasource="#Session.DSN#">
		select 
 		convert(varchar,a.FCid) as FCid, a.FCcodigo, a.FCdesc
		from FCajas a
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        and FCestado = 1	
	</cfquery>
    
<cfif modo NEQ "ALTA">	    
    <cfquery name="rsCodigosLineas" datasource="#session.dsn#">
      select a.FACCid, a.FCid, a.Cid,a.Ccodigo,c.Cdescripcion, a.CFid
             from FACodigosConceptos a
                inner join Conceptos c
                  on a.Cid = c.Cid
                  and a.Ecodigo = c.Ecodigo
                inner join CFuncional cf
                  on a.CFid = cf.CFid 
                  and a.Ecodigo = cf.Ecodigo
                inner join FCajas f
                  on a.FCid = f.FCid
                 and a.Ecodigo = f.Ecodigo
            where a.FACCid =    #form.FACCid# 
    </cfquery>
    <cfquery name="rsCajas" datasource="#Session.DSN#">
		select 
 		convert(varchar,a.FCid) as FCid, a.FCcodigo, a.FCdesc
		from FCajas a
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        and FCestado = 1
	    and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">		
	</cfquery>    

	
</cfif>



<form action="SQLCodigosConceptos.cfm" method="post" name="form1" onsubmit="return validarFormulario();">
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr> 
      <td width="30%" align="right" nowrap><label id="idCaja">Caja:&nbsp;</label></td>
       <td colspan="2" nowrap><select name="FCid" onchange="setCodigo(this.value)">
          <cfoutput query="rsCajas"> 
            <cfif modo EQ 'ALTA'>
              <option value="#rsCajas.FCid#">#rsCajas.FCcodigo#-#rsCajas.FCdesc#</option>
              <cfelse>
              <option value="#rsCajas.FCid#" <cfif #rsCajas.FCid# EQ #Session.Caja#>selected</cfif>>#rsCajas.FCcodigo#-#rsCajas.FCdesc#</option>
            </cfif>
      </cfoutput> </select></td> 
      <input type="hidden" name="FCcodigo" id="FCcodigo" /> 
      <cfif modo NEQ 'ALTA'>
      <input type="hidden" name="FACCid" id="FACCid" value="<cfoutput>#rsCodigosLineas.FACCid#</cfoutput>"/> 
      </cfif>
    </tr>
    <tr> 
      <td align="right"><label id="idconc">Conceptos:&nbsp;</label></td>
            
        <cfif modo EQ 'ALTA'>               
           <td valign="middle" colspan="2" >   
              <cf_sifconceptos  tabindex="1" Ecodigo="#session.Ecodigo#">               
           </td>
        <cfelse>
           <td valign="middle" colspan="2" >   
               <cf_sifconceptos query="#rsCodigosLineas#" desc="Cdescripcion" tabindex="2" Ecodigo="#session.Ecodigo#">
           </td>
        </cfif>      
    </tr>
   <td valign="middle" align="right"><label id="CFlabel">Centro Funcional:</label></td>
      <td colspan="2">         <cfset valuesArraySN = ArrayNew(1)>
					<cfif isdefined("rsCodigosLineas.CFid") and len(trim(rsCodigosLineas.CFid))>
						<cfquery datasource="#Session.DSN#" name="rsSN">
							select 
							CFid,
							CFcodigo,
							CFdescripcion
							from CFuncional			
							where Ecodigo = #session.Ecodigo#
							and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCodigosLineas.CFid#">
						</cfquery>
						
						<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
						<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
						<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
						
					</cfif>   
					<cf_conlis
						Campos="CFid,CFcodigo,CFdescripcion"
						valuesArray="#valuesArraySN#"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						tabindex="5"
						Title="Lista de Centros Funcionales"
						Tabla="CFuncional cf 
						inner join Oficinas o 
						on o.Ecodigo=cf.Ecodigo 
						and o.Ocodigo=cf.Ocodigo"
						Columnas="distinct cf.CFid,cf.CFcodigo,cf.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcion"
						Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
						Desplegar="CFcodigo,CFdescripcion"
						Etiquetas="Codigo,Descripcion"
						filtrar_por="cf.CFcodigo,CFdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CFid,CFcodigo,CFdescripcion"
						Asignarformatos="S,S,S,S"											
					/> 
		</td>     
    </tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td>&nbsp;</td></tr>
  <tr>
  	<td nowrap align="center">

		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>	
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript: return confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
    function validarFormulario()
	{
 		 var f = document.form1;		
 
		 var errors = '';
	 	 if(f.FCid.value == '')
		 {
	       errors = 'La caja es requerida.\n';
		 }
		 if(f.Cid.value == '')
    	 {
	       errors += 'El concepto es requerido.\n';
		 }
		 if(f.CFid.value == '')
    	 {
	       errors += 'El centro funcional es requerido.\n';
		 }
		
		if(errors)
		{
			alert('Se presentaron los siguientes errores:\n\n'+errors) 
			return false;			
		}
	    else
	    {
			return true;
		}		 
    

	}
	function setCodigo(FCid)
	{
			var f = document.form1;			
			 <cfloop query="rsCajas">
			   if (FCid == "<cfoutput>#rsCajas.FCid#</cfoutput>") {
					f.FCcodigo.value="<cfoutput>#rsCajas.FCcodigo#</cfoutput>";
			  }
			 </cfloop>			 
	}	
</script>