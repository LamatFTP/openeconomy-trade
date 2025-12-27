<script setup lang="ts">
useHead({
  title: 'Terms of Service',
  meta: [
    {
      name: 'description',
      content: 'OpenEconomy terms of service and user agreement.',
    },
  ],
})
</script>

<template>
  <LayoutContainer class="py-16">
    <div class="prose dark:prose-invert mx-auto max-w-3xl">
      <h1>Terms of Service</h1>
      <p class="lead">Last updated: {{ new Date().toLocaleDateString() }}</p>

      <h2>Agreement to Terms</h2>
      <p>
        By accessing and using OpenEconomy, you accept and agree to be bound by
        these Terms of Service. If you do not agree, please do not use our
        platform.
      </p>

      <h2>Platform Purpose</h2>
      <p>
        OpenEconomy is a decentralized time-value exchange platform that enables
        participants to trade skills and services fairly without monetary
        transactions.
      </p>

      <h2>User Accounts</h2>
      <h3>Registration</h3>
      <ul>
        <li>You must provide accurate and complete information</li>
        <li>You are responsible for maintaining account security</li>
        <li>One account per person</li>
        <li>You must be at least 18 years old</li>
      </ul>

      <h3>Account Responsibilities</h3>
      <ul>
        <li>Keep your credentials confidential</li>
        <li>Notify us immediately of unauthorized access</li>
        <li>You are responsible for all activity under your account</li>
      </ul>

      <h2>Platform Usage</h2>
      <h3>Permitted Use</h3>
      <ul>
        <li>Fair and honest exchanges with other participants</li>
        <li>Accurate representation of your skills and availability</li>
        <li>Respectful communication</li>
        <li>Compliance with all applicable laws</li>
      </ul>

      <h3>Prohibited Conduct</h3>
      <ul>
        <li>Fraud, misrepresentation, or deception</li>
        <li>Harassment or abusive behavior</li>
        <li>Spam or unsolicited promotions</li>
        <li>Attempting to circumvent platform systems</li>
        <li>Commercial exploitation without permission</li>
      </ul>

      <h2>Exchanges</h2>
      <p>
        All exchanges are agreements between participants. OpenEconomy
        facilitates connections but is not party to exchange agreements.
      </p>

      <h3>Value Setting</h3>
      <ul>
        <li>You determine your own hourly value</li>
        <li>Values should reflect fair self-assessment</li>
        <li>Trust system helps maintain fairness</li>
      </ul>

      <h3>Dispute Resolution</h3>
      <ul>
        <li>Participants should first attempt direct resolution</li>
        <li>Community mediation available for disputes</li>
        <li>Repeated violations may result in account restrictions</li>
      </ul>

      <h2>Intellectual Property</h2>
      <p>
        OpenEconomy and its content are protected by copyright and other
        intellectual property rights. You may not copy, modify, or distribute
        platform content without permission.
      </p>

      <h2>Disclaimer of Warranties</h2>
      <p>
        The platform is provided "as is" without warranties of any kind. We do
        not guarantee uninterrupted access or error-free operation.
      </p>

      <h2>Limitation of Liability</h2>
      <p>
        OpenEconomy is not liable for indirect, incidental, or consequential
        damages arising from platform use or exchanges between participants.
      </p>

      <h2>Termination</h2>
      <p>
        We reserve the right to suspend or terminate accounts that violate these
        terms or engage in harmful conduct.
      </p>

      <h2>Changes to Terms</h2>
      <p>
        We may modify these terms at any time. Continued use after changes
        constitutes acceptance of new terms.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about these Terms? Contact us at:
        <a href="mailto:legal@openeconomy.trade" class="text-brand-500"
          >legal@openeconomy.trade</a
        >
      </p>
    </div>
  </LayoutContainer>
</template>
