<cfinvoke 
 component="educ.componentes.pTabs2"
 method="fnTabsInclude">
	<cfinvokeargument name="pTabID" value="TabsFactura"/>
	<cfinvokeargument name="pTabs" value=
		 #"|Detalle,Detfactura.cfm,Trabajar con el detalle de la factura"
		& "|Pagos,facturaFormaPago.cfm,Detalle del pago a la factura"
		#
	/> 
	<cfparam name="Form.PBLsecuencia" default="">
	<cfparam name="Form.PEScodigo" default="">
	<cfparam name="Form.CARcodigo" default="">	
	<cfparam name="Form.TabsPlan" default="1">		
 	<cfinvokeargument name="pDatos" value="codApersona=#form.codApersona#,FACcodigo=#form.FACcodigo#"/> 
	<cfinvokeargument name="pNoTabs" value="#(form.Modo EQ 'ALTA' )#"/>
	<cfinvokeargument name="pWidth" value="100%"/>
</cfinvoke>