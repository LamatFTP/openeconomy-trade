<script setup lang="ts">
useHead({
  title: 'Cookie Policy',
  meta: [
    {
      name: 'description',
      content: 'OpenEconomy cookie usage and preferences.',
    },
  ],
})
</script>

<template>
  <LayoutContainer class="py-16">
    <div class="prose dark:prose-invert mx-auto max-w-3xl">
      <h1>Cookie Policy</h1>
      <p class="lead">Last updated: {{ new Date().toLocaleDateString() }}</p>

      <h2>What Are Cookies?</h2>
      <p>
        Cookies are small text files stored on your device when you visit a
        website. They help websites remember your preferences and improve your
        experience.
      </p>

      <h2>How We Use Cookies</h2>

      <h3>Essential Cookies (Required)</h3>
      <p>These cookies are necessary for the platform to function:</p>
      <ul>
        <li>
          <strong>Authentication:</strong> Keep you logged in
        </li>
        <li>
          <strong>Security:</strong> Protect against fraud and abuse
        </li>
        <li>
          <strong>Preferences:</strong> Remember your settings (theme, language)
        </li>
      </ul>

      <h3>Analytics Cookies (Optional)</h3>
      <p>Help us understand how people use the platform:</p>
      <ul>
        <li>Page views and navigation patterns</li>
        <li>Platform performance metrics</li>
        <li>Error tracking and debugging</li>
      </ul>

      <h2>Cookie Types</h2>

      <table>
        <thead>
          <tr>
            <th>Cookie</th>
            <th>Purpose</th>
            <th>Duration</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>oe_auth</td>
            <td>Authentication token</td>
            <td>30 days</td>
          </tr>
          <tr>
            <td>oe_theme</td>
            <td>Dark/light mode preference</td>
            <td>1 year</td>
          </tr>
          <tr>
            <td>oe_session</td>
            <td>Session management</td>
            <td>Session</td>
          </tr>
        </tbody>
      </table>

      <h2>Managing Cookies</h2>

      <h3>Browser Settings</h3>
      <p>You can control cookies through your browser settings:</p>
      <ul>
        <li>Block all cookies (may affect functionality)</li>
        <li>Delete existing cookies</li>
        <li>Allow only certain cookies</li>
      </ul>

      <h3>Platform Settings</h3>
      <p>
        Once logged in, you can manage optional cookie preferences in your
        <NuxtLink to="/dashboard/settings" class="text-brand-500"
          >account settings</NuxtLink
        >.
      </p>

      <h2>Third-Party Cookies</h2>
      <p>We do not use third-party advertising cookies. We may use:</p>
      <ul>
        <li>
          <strong>Firebase:</strong> For authentication and data storage
        </li>
        <li>
          <strong>Analytics:</strong> For privacy-friendly usage analytics
          (optional)
        </li>
      </ul>

      <h2>Changes to This Policy</h2>
      <p>
        We may update this Cookie Policy. Changes will be posted on this page
        with an updated date.
      </p>

      <h2>More Information</h2>
      <p>
        For more details about how we handle your data, see our
        <NuxtLink to="/privacy" class="text-brand-500">Privacy Policy</NuxtLink
        >.
      </p>

      <p>
        Questions? Contact us at:
        <a href="mailto:privacy@openeconomy.trade" class="text-brand-500"
          >privacy@openeconomy.trade</a
        >
      </p>
    </div>
  </LayoutContainer>
</template>
