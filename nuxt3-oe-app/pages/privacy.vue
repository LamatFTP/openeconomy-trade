<script setup lang="ts">
useHead({
  title: 'Privacy Policy',
  meta: [
    {
      name: 'description',
      content: 'OpenEconomy privacy policy and data protection information.',
    },
  ],
})
</script>

<template>
  <LayoutContainer class="py-16">
    <div class="prose dark:prose-invert mx-auto max-w-3xl">
      <h1>Privacy Policy</h1>
      <p class="lead">Last updated: {{ new Date().toLocaleDateString() }}</p>

      <h2>Introduction</h2>
      <p>
        OpenEconomy ("we", "our", or "us") is committed to protecting your
        privacy. This Privacy Policy explains how we collect, use, disclose, and
        safeguard your information when you use our platform.
      </p>

      <h2>Information We Collect</h2>
      <h3>Account Information</h3>
      <ul>
        <li>Email address</li>
        <li>Profile information (name, bio, skills)</li>
        <li>Authentication credentials</li>
      </ul>

      <h3>Usage Data</h3>
      <ul>
        <li>Exchange history and activity</li>
        <li>Messages and communications</li>
        <li>Platform usage analytics</li>
      </ul>

      <h2>How We Use Your Information</h2>
      <p>We use the information we collect to:</p>
      <ul>
        <li>Provide and maintain our platform</li>
        <li>Facilitate fair exchanges between participants</li>
        <li>Improve and personalize your experience</li>
        <li>Communicate with you about platform updates</li>
        <li>Prevent fraud and abuse</li>
      </ul>

      <h2>Data Sharing</h2>
      <p>
        We do not sell your personal information. We may share data only when:
      </p>
      <ul>
        <li>You explicitly consent</li>
        <li>Required by law</li>
        <li>Necessary to provide platform services</li>
        <li>To protect rights and safety</li>
      </ul>

      <h2>Data Security</h2>
      <p>
        We implement appropriate technical and organizational measures to protect
        your personal data. However, no method of transmission over the internet
        is 100% secure.
      </p>

      <h2>Your Rights</h2>
      <p>You have the right to:</p>
      <ul>
        <li>Access your personal data</li>
        <li>Correct inaccurate data</li>
        <li>Request deletion of your data</li>
        <li>Export your data</li>
        <li>Opt-out of certain data processing</li>
      </ul>

      <h2>Cookies</h2>
      <p>
        We use essential cookies to provide platform functionality. See our
        <NuxtLink to="/cookies" class="text-brand-500">Cookie Policy</NuxtLink>
        for details.
      </p>

      <h2>Changes to This Policy</h2>
      <p>
        We may update this Privacy Policy from time to time. We will notify you
        of any changes by posting the new policy on this page.
      </p>

      <h2>Contact Us</h2>
      <p>
        If you have questions about this Privacy Policy, please contact us at:
        <a href="mailto:privacy@openeconomy.trade" class="text-brand-500"
          >privacy@openeconomy.trade</a
        >
      </p>
    </div>
  </LayoutContainer>
</template>
