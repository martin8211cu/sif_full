<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Nombre del parche </h1>
<cfquery datasource="asp" name="APEsquema">
	select e.esquema, e.nombre, upper(e.nombre) as upper_nombre,
		coalesce ( 
			(select max(p3.pnum) from APParche p3 
				<!---where p3.pdir = e.esquema--->
			) , '1') as max_pnum,
		coalesce ( 
			(select max (p2.psec) from APParche p2
				where p2.pnum = 
					(
						select max(p3.pnum) from APParche p3 
						<!---where p3.pdir = e.esquema---> 
					) 
				<!--- and p2.pdir = e.esquema--->
			)
			, '0') as max_psec
	from APEsquema e
	<!---
		left join APParche p
			on e.esquema = p.pdir
	--->
	group by e.esquema, e.nombre, upper(e.nombre)
	order by upper(e.nombre)

</cfquery>
<cfoutput>
<script type="text/javascript">
<!--
function evdirchange(f){
<cfloop query="APEsquema">
	if (f.pdir.value == '# JSStringFormat( esquema ) #') {
		f.pnum.value = '# JSStringFormat( NumberFormat( Val(max_pnum) , '000') ) #';
		f.psec.value = '# JSStringFormat( NumberFormat( Val(max_psec) + 1 , '000') ) #';
	}
</cfloop>
}
//-->
</script>
  <cfform height="300" width="700" id="form1" name="form1" method="post" action="admguardar-control.cfm" format="#session.parche.form_format#" >
<cf_web_portlet_start width="700" titulo="Revise los datos del parche que va a guardar">
<cfif session.parche.form_format EQ 'html'>
	<cfset onblur = 
		"this.form.pnum.value='000'.substring(0,3-this.form.pnum.value.length)+this.form.pnum.value;"&
		"this.form.psec.value='000'.substring(0,3-this.form.psec.value.length)+this.form.psec.value;"&
		"this.form.nombre.value='Parche'+this.form.pnum.value+'_'+this.form.psec.value+'_'+"&
		"this.form.pdir.value+(this.form.psub.value!=''?'_':'')+this.form.psub.value">
	<cfset onchange = "evdirchange(this.form);" >
<cfelse>
	<cfset onblur = "">
	<cfset onchange = "evdirchange()">
	<cfformitem type="script">
		function evdirchange()	{
		<cfloop query="APEsquema">
			if (pdir.value == '# JSStringFormat( esquema ) #') {
				pnum.text = '# JSStringFormat( NumberFormat( Val(max_pnum) , '000') ) #';
				psec.text = '# JSStringFormat( NumberFormat( Val(max_psec) + 1 , '000') ) #';
			}
		</cfloop>
		}
	</cfformitem>
</cfif>
    <cfformgroup label="Indique y revise los datos del parche que se va a guardar" type="panel">
	<table>
	<tr><td><label for="pdir">Secuencia y parche</label></td><td>
    <cfformgroup label="Secuencia y parche" type="horizontal">
    <cfselect name="pdir" id="pdir" width="75" onBlur="#onblur#" onChange="#onchange#" required="yes"
		selected="#session.parche.info.pdir#" query="APEsquema" value="esquema" display="nombre" queryPosition="below" >
	<cfif Len(session.parche.guid) EQ 0>
		<option value="">-Seleccione-</option>
	</cfif>
    </cfselect>
    <cfinput name="pnum" type="text" id="pnum" value="#session.parche.info.pnum#" size="6" maxlength="3"  mask="999" required="yes" range="1,999" onBlur="#onblur#" />
    <cfinput name="psec" type="text" id="psec" value="#session.parche.info.psec#" size="6" maxlength="3"  mask="999" required="yes" range="1,999" onBlur="#onblur#" />
    <cfinput name="psub" type="text" id="psub" value="#session.parche.info.psub#" size="18" maxlength="60"  onBlur="#onblur#" />
    </cfformgroup>
	</td></tr>
	<tr><td><label for="modulo">Módulo(s) afectado(s)</label></td><td>
    <cfinput label="Módulo(s) afectado(s)" name="modulo" value="#session.parche.info.modulo#" type="text" id="modulo" size="50" required="yes" />
	</td></tr>
	<tr><td><label for="nombre">Nombre del parche</label></td><td>
	<cfparam name="url.ff" default="html">
	<cfif url.ff EQ "flash">
		<cfset LvarBind = "Parche{'000'.substring(0,3-pnum.text.length)}{pnum.text}_{'000'.substring(0,3-psec.text.length)}{psec.text}_{pdir.value}{psub.text!=''?'_':''}{psub.text}">
	<cfelse>
		<cfset LvarBind = "">
	</cfif>
    <cfinput label="Nombre del parche" name="nombre" type="text" id="nombre" value="#session.parche.info.nombre#" size="50" readonly="yes" required="yes" 
		   bind="#LvarBind#" />
	</td></tr>
	<tr><td><label for="autor">Autor del parche</label></td><td>
    <cfinput label="Autor del parche" name="autor" type="text" id="autor" value="#session.parche.info.autor#" size="50"  required="yes"/>
	</td></tr>	
	<tr><td valign="top"><label for="descripcion">Descripción</label></td><td valign="top">
	<cftextarea label="Descripción" name="descripcion" id="descripcion" required="no" cols="50" rows="3"><cfoutput>#session.parche.info.descripcion#</cfoutput></cftextarea>
	</td></tr>
	<tr><td valign="top"><label for="instruccion">Instrucciones</label></td><td valign="top">
	<cftextarea label="Instrucciones" name="instrucciones" id="instrucciones"  required="no" cols="50" rows="3"><cfoutput>#session.parche.info.instrucciones#</cfoutput></cftextarea> 
	</td></tr>
	<tr><td>&nbsp;</td><td>
    <cfinput label="Se deben regenerar las vistas después de instalar este parche" id="vistas" name="vistas" type="checkbox" value="1" checked="#session.parche.info.vistas#"/>
	<label for="vistas">Se deben regenerar las vistas después de instalar este parche</label>
	</td></tr>
	<tr><td colspan="2" align="right">
    <cfinput name="guardar" type="submit" id="guardar" value="Guardar" class="btnGuardar"/>
    <cfinput name="siguiente" type="submit" id="siguiente" value="Siguiente" class="btnSiguiente"/>
	</td></tr></table>
    </cfformgroup>
	<cf_web_portlet_end>
  </cfform>
</cfoutput>

<cf_templatefooter>
