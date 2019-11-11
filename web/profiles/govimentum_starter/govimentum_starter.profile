<?php

use Drupal\Core\Form\FormStateInterface;
/**
 * @file
 * Enables modules and site configuration for a standard site installation.
 */

// Add any custom code here like hook implementations.

// Site configuration task override
function govimentum_starter_form_install_configure_form_alter(
    &$form,
    FormStateInterface $form_state) {

    // make forms collapsible
    $form['site_information']['#type'] = 'details';
    $form['site_information']['#open'] = true;
    $form['admin_account']['#type'] = 'details';
    $form['admin_account']['#open'] = false;
    $form['regional_settings']['#type'] = 'details';
    $form['regional_settings']['#open'] = false;
    $form['update_notifications']['#type'] = 'details';
    $form['update_notifications']['#open'] = false;

    // set default sitename
    $form['site_information']['site_name']['#default_value'] = 'NOMBRE ENTIDAD';

    // enable configuration option for default content
    $form['configure_content'] = array(
        '#type' => 'details',
        '#title' => t('Configuración del contenido'),
        '#open' => false,
    );

    $form['configure_content']['enable_content'] = array(
        '#type' => 'checkbox',
        '#title' => t('Instalar contenido de ejemplo'),
        '#description' => t('<br/>Active esta opción para instalar contenido de ejemplo en el sitio web. Recomendamos habilitar este contenido en un ambiente de pruebas para conocer como se presenta la información en los bloques temáticos de las secciones de Transparencia y Acceso a la Información Pública, Noticias, Eventos, Enlaces destacados, etc. No utilice este contenido de ejemplo en el ambiente de producción ya que pude interferir con el posicionamiento y accesibilidad web de los contenidos oficiales de la Entidad'),
        '#default_value' => false
    );

    // Add fields for proxy configuration
    $form['proxy_configuration'] = array(
        '#type' => 'details',
        '#title' => t('Configuración del Proxy'),
        '#open' => false,
    );

    $form['proxy_configuration']['http_server'] = array(
        '#type' => 'textfield',
        '#title' => t('Servidor http'),
    );
    $form['proxy_configuration']['http_port'] = array(
        '#type' => 'textfield',
        '#title' => t('Puerto')
    );
    $form['proxy_configuration']['http_exceptions'] = array(
        '#type' => 'textfield',
        '#title' => 'Excepciones',
        '#description' => t('Lista separada por comas'),
    );

    $form['#submit'][] = 'govimentum_starter_form_install_configure_form_alter_submit';
}

function govimentum_starter_form_install_configure_form_alter_submit(
    &$form,
    FormStateInterface $form_state) {

    $exceptions = $form_state->getValue('http_exceptions');

    $urls = array();

    if (strpos($exceptions, ',')) {
        $exceptions = explode(',', $exceptions);
        foreach ($exceptions as $url) {
            array_push($urls, trim($url));
        }
    } else {
        array_push($urls, trim($exceptions));
    }

    \Drupal::configFactory()->getEditable('govimentum_starter.settings')
      ->set('enable_content', $form_state->getValue('enable_content'))
      ->set('proxy_server', $form_state->getValue('http_server'))
      ->set('proxy_port', $form_state->getValue('http_port'))
      ->set('proxy_exceptions', $urls)
      ->save();
}
